class BattlesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_battle, only: [:show, :edit, :update, :destroy]

  def index
    @battles = Battle.all
  end

  def show
    @player = current_user
    @opponent = (@battle.users - [current_user]).first.inspect
  end

  def new
    @battle = Battle.new
  end

  def edit
  end

  def create
    opponent = User.find(params[:opponent_id])
    @battle = Battle.new(users: [current_user, opponent])

    if @battle.save
      WebsocketRails.users[params[:opponent_id]].send_message 'battle.joined', @battle
      redirect_to @battle, notice: 'Battle was successfully created.'
    else
      render :new
    end
  end

  def update
    if @battle.update(battle_params.merge(users: [current_user]))
      redirect_to @battle, notice: 'Battle was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @battle.destroy
    redirect_to battles_url, notice: 'Battle was successfully destroyed.'
  end

  private
    def set_battle
      @battle = Battle.find(params[:id])
    end

    def battle_params
      params.require(:battle).permit(:active)
    end
end
