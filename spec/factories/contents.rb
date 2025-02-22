# frozen_string_literal: true

FactoryBot.define do
  factory :content do
    title { 'Sample Title' }
    body { 'Sample Body' }
    association :user, factory: :user
  end
end
