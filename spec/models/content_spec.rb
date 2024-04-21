require 'rails_helper'

RSpec.describe Content, type: :model do
  let(:user) { create(:user) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      content = Content.new(title: 'Title', body: 'Body', user: user)
      expect(content).to be_valid
    end

    it 'is not valid without a title' do
      content = Content.new(body: 'Body', user: user)
      expect(content).not_to be_valid
      expect(content.errors[:title]).to include("can't be blank")
    end

    it 'is not valid without a body' do
      content = Content.new(title: 'Title', user: user)
      expect(content).not_to be_valid
      expect(content.errors[:body]).to include("can't be blank")
    end
  end

  describe 'Associations' do
    it 'belongs to a user without validating presence' do
      expect(Content.reflect_on_association(:user).macro).to eq(:belongs_to)
    end
  end
end
