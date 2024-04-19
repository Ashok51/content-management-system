class Content < ApplicationRecord
  validates :title, :body, presence: true
end
