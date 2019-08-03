Rails.application.routes.draw do
  devise_for :people, controllers: { omniauth_callbacks: 'people/omniauth_callbacks' }

  get '/landing' => 'landing#show'
  root to: 'landing#show'
end
