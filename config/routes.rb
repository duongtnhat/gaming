Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  scope :admin_custom do
    get '/sign_in', to: "admin_session#get"
    post '/sign_in', to: "admin_session#post"
  end

  scope :api do
    devise_for :users
    get "/game", to: "lotto#game_by_code"
    get "/game/:id", to: "lotto#game_by_id"
    get "/schema/:code", to: "lotto#schema_by_code"
    get "/player/account", to: "player#account"
    get "/player/bet", to: "player#my_bet"
    post "/player/bet", to: "player#place_bet"
    post "/player/bet_batch", to: "player#place_bet_batch"
    get "/config", to: "config#index"
    get "/presale", to: "payment#presale"
    post "/presale", to: "payment#create_presale"
    get "/payment", to: "payment#index"
    get "/payment/refresh", to: "payment#refresh"
    post "/payment/create", to: "payment#create"
    post "/payout/create", to: "payment#payout"
    get "/taixiu/live", to: "live#taixiu_live"
    get "/health", to: "health#health"
  end
end
