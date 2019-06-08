Rails.application.routes.draw do
  mount ForestLiana::Engine => '/forest'
  authenticated :user do
    root to: 'businesses#index'
  end
  root to: 'pages#home'
  devise_for :users,
  controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
  resources :businesses do
    resources :expenses do
      member do
        get '/print', to: "expenses#print", defaults: { format: 'pdf' }
      end
    end
  end
  require "sidekiq/web"
    authenticate :user, lambda { |u| u.admin } do
      mount Sidekiq::Web => '/sidekiq'
    end
  get '/support', to: "pages#support"
end
