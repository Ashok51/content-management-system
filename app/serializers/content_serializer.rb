class ContentSerializer < ActiveModel::Serializer
  type 'content'
  attributes :id,
             :title,
             :body,
             :createdAt,
             :updatedAt

  def createdAt
    object.created_at.strftime('%Y-%m-%dT%H:%M%:z')
  end

  def updatedAt
    object.updated_at.strftime('%Y-%m-%dT%H:%M%:z')
  end
end
