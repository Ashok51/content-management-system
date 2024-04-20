class UserSerializer < ActiveModel::Serializer
  
  type 'user'

  attributes :id, :email, :name, :country, :createdAt, :updatedAt

  def name
    "#{object.first_name} #{object.last_name}"
  end

  def createdAt
    object.created_at.iso8601
  end

  def updatedAt
    object.updated_at.iso8601
  end
end
