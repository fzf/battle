class NpcsController < ApplicationController
  before_action :set_npc, only: [:show, :edit, :update, :destroy]

  # GET /npcs
  def index
    @npcs = Npc.all
  end

  # GET /npcs/1
  def show
  end

  # GET /npcs/new
  def new
    @npc = Npc.new
  end

  # GET /npcs/1/edit
  def edit
  end

  # POST /npcs
  def create
    @npc = Npc.new(npc_params)

    if @npc.save
      redirect_to @npc, notice: 'Npc was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /npcs/1
  def update
    if @npc.update(npc_params)
      redirect_to @npc, notice: 'Npc was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /npcs/1
  def destroy
    @npc.destroy
    redirect_to npcs_url, notice: 'Npc was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_npc
      @npc = Npc.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def npc_params
      params.permit(:npc).permit(:current_hit_points,
        :hit_points,
        actions_attributes: [
          :_id,
          :name,
          :damage,
          :piercing,
          :defense
        ]
      )
    end
end
