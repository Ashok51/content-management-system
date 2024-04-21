# frozen_string_literal: true

Rails.application.routes.draw do
  devise_scope :user do
    scope '/api/v1' do
      post 'users/signup', to: 'api/v1/registrations#create'

      post 'auth/signin', to: 'api/v1/sessions#create'
    end
  end

  mount_devise_token_auth_for 'User', at: '/api/v1/auth', controllers: {
    registrations: 'api/v1/registrations',
    sessions: 'api/v1/sessions'
  }

  namespace :api do
    namespace :v1 do
      resources :contents
    end
  end
end
