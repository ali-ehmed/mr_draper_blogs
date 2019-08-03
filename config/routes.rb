Rails.application.routes.draw do
  # Devise
  devise_for :people, controllers: { omniauth_callbacks: 'people/omniauth_callbacks' }

  # Blogs
  resources :blogs

  # Landing Page
  get '/landing' => 'landing#show'

  # Root
  root to: 'landing#show'
end
