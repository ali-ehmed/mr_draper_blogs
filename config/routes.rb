Rails.application.routes.draw do
  devise_for :people, controllers: { omniauth_callbacks: 'people/omniauth_callbacks' }

  get '/home' => 'home#show'
  root to: 'home#show'
end
