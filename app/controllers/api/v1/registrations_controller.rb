module Api
  module V1
    class RegistrationsController < DeviseTokenAuth::RegistrationsController
      respond_to :json

      def create
        @resource = User.new(sign_up_params)

        if @resource.save
          update_auth_header
          render json: @resource,
                 serializer: UserSerializer,
                 adapter: :json_api
        else
          render json: { message: @resource.errors.full_messages.join(', ') }, status: :bad_request
        end
      end

      private

      def sign_up_params
        sanitized_params.permit(:email, :password, :first_name, :last_name, :country)
      end

      def sanitized_params
        params.require(:registration).transform_keys { |key| key.underscore.to_sym }
      end
    end
  end
end
