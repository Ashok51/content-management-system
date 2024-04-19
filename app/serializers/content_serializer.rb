class ContentSerializer < ActiveModel::Serializer
  type 'content'

  attributes :id,
             :title,
             :body,
             :createdAt,
             :updatedAt

  def createdAt
    object.created_at
  end

  def updatedAt
    object.updated_at
  end
end
