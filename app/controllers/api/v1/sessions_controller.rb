module Api
  module V1
    class SessionsController < DeviseTokenAuth::SessionsController
      # Override the method
      def render_create_success
        render json: @resource,
               serializer: UserSerializer,
               adapter: :json_api
      end

      private

      def resource_params
        auth = params[:auth] || params[:session][:auth]
        auth.permit(:email, :password) if auth
      end
    end
  end
end
