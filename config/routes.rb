Rails.application.routes.draw do
  devise_for :people

  get '/home' => 'home#show'
  root to: 'home#show'
end
