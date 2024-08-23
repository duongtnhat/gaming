Rails.application.routes.draw do
  devise_for :users
  get "/game", to: "lotto#game_by_code"
  get "/game/:id", to: "lotto#game_by_id"
  get "/schema/:code", to: "lotto#schema_by_code"
  get "/player/account", to: "player#account"
  get "/player/bet", to: "player#my_bet"
  post "/player/bet", to: "player#place_bet"
end
