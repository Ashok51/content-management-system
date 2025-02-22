# frozen_string_literal: true

class Content < ApplicationRecord
  validates :title, :body, presence: true

  belongs_to :user
end
