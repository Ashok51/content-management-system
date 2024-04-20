Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: '/api/v1/auth', controllers: {
    registrations: 'api/v1/registrations',
    sessions: 'api/v1/sessions'
  }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :contents
    end
  end
end
