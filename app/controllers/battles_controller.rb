class BattlesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_battle, only: [:play, :show, :edit, :update, :destroy]

  def index
    @battles = current_user.battles
  end

  def show
    @player = current_user
    @opponent = (@battle.users - [current_user]).first || @battle.npc
  end

  def play
    @action = Action.find(params[:action_id])
    @battle.send_action(@action)
    redirect_to :back
  end

  def new
    @battle = Battle.new
  end

  def edit
  end

  def create
    opponent = User.find(params[:opponent_id]) || Npc.find(params[:opponent_id])
    if opponent.class == User
      @battle = Battle.new(users: [current_user, opponent])
    else
      @battle = Battle.new(users: [current_user], npc: opponent)
    end

    if @battle.save
      current_user.save
      opponent.save
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
