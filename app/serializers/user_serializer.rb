# frozen_string_literal: true

class UserSerializer < ActiveModel::Serializer
  type 'user'

  attributes :id,
             :email,
             :name,
             :country,
             :created_at,
             :updated_at,
             :token

  def name
    "#{object.first_name} #{object.last_name}"
  end

  def created_at
    object.created_at.strftime('%Y-%m-%dT%H:%M%:z')
  end

  def updated_at
    object.updated_at.strftime('%Y-%m-%dT%H:%M%:z')
  end

  def token
    @instance_options[:authorization_token]
  end
end
