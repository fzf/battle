class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  def index
    @users = User.all
  end

  def show
  end

  def edit
  end

  def update
    if @user.update(user_params.merge(users: [current_user]))
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

private
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:active)
  end
end
