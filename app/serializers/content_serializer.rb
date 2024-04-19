class ContentSerializer < ActiveModel::Serializer
  type 'content'
  attributes :id,
             :title,
             :body,
             :created_at,
             :updated_at

  def created_at
    object.created_at.strftime('%Y-%m-%dT%H:%M%:z')
  end

  def updated_at
    object.updated_at.strftime('%Y-%m-%dT%H:%M%:z')
  end
end
