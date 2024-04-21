# frozen_string_literal: true

module Api
  module V1
    class SessionsController < DeviseTokenAuth::SessionsController
      def create
        super do |resource|
          if resource && response.status == 200
            render json: resource, serializer: UserSerializer,
                   authorization_token: auth_headers(resource)['Authorization'],
                   adapter: :json_api

            return
          end
        end
      end

      private

      def resource_params
        auth = params[:auth] || params[:session][:auth]
        auth&.permit(:email, :password)
      end

      def auth_headers(resource)
        resource.create_new_auth_token
      end
    end
  end
end
