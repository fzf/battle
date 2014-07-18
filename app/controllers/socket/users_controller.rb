class Socket::UsersController < WebsocketRails::BaseController
  def index
    if controller_store[:users]
      controller_store[:users] << current_user unless controller_store[:users].include?(current_user)
    else
      controller_store[:users] = [current_user]
    end
    WebsocketRails[:users].trigger 'available', current_user

    trigger_success controller_store[:users]
  end

  def disconnected
    WebsocketRails[:users].trigger 'disconnected', current_user
  end
end
