Rails.application.routes.draw do
  # Sidekiq
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  # Devise
  devise_for :people, controllers: { omniauth_callbacks: 'people/omniauth_callbacks' }

  # Protected Routes
  authenticate :person do
    namespace :people do
      # Blogs
      resources :blogs do
        resource :publish, controller: 'blogs/publish', only: %i[new create] do
          get :schedule_for_later, on: :collection
        end
      end
    end
  end

  # Blogs
  resources :blogs, only: %i[index show]

  # Active Storage Attachment
  resources :attachments, only: %i[destroy]

  # Landing Page
  get '/landing' => 'landing#show'

  # Settings
  resource :settings, only: %i[update]
  # Profile
  get '/:username' => 'profile#show', as: :profile

  # Root
  root to: 'landing#show'
end
