Rails.application.routes.draw do
  get '/game', to: "words_game#game"

  get '/score', to: "words_game#score"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
