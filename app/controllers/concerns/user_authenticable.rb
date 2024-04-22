# frozen_string_literal: true

module UserAuthenticable
  extend ActiveSupport::Concern

  def render_with_auth_token(resource)
    render json: resource, serializer: UserSerializer,
           authorization_token: auth_headers(resource)['Authorization'],
           adapter: :json_api
  end

  def auth_headers(resource)
    resource.create_new_auth_token
  end
end
