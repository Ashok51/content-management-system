# frozen_string_literal: true

# app/controllers/api/v1/sessions_controller.rb

module Api
  module V1
    class SessionsController < ApplicationController

      include UserAuthenticable

      respond_to :json

      def create
        resource = User.find_by(email: resource_params[:email])

        if resource&.valid_password?(resource_params[:password])
          render_with_auth_token(resource)
        else
          render json: { error: 'Invalid email or password' }, status: :unauthorized
        end
      end

      private

      def resource_params
        auth = params[:auth] || params[:session][:auth]
        auth&.permit(:email, :password)
      end
    end
  end
end
