WebsocketRails::EventMap.describe do
  namespace :users do
    subscribe :index, to: Socket::UsersController, with_method: :index
  end
  subscribe :client_disconnected, :to => Socket::UsersController, :with_method => :disconnected
end
