require 'rails_helper'

RSpec.describe 'Contents API', type: :request do
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let!(:content1) { create(:content, user: user1) }
  let!(:content2) { create(:content, user: user2) }
  let(:auth_headers1) { user1.create_new_auth_token }
  let(:auth_headers2) { user2.create_new_auth_token }

  context 'index' do
    it 'logged in user can view all the contents present' do
      get '/api/v1/contents', 
        headers: { 'Content-Type': 'application/json',
                   'Authorization': auth_headers1['Authorization'] }

      expect(response.status).to eq(200)
      expect(JSON(response.body)["data"].count).to eq(2)
    end

    it 'not signed in user / without having auth token or invalid token' do
      get '/api/v1/contents', 
        headers: { 'Content-Type': 'application/json',
                   'Authorization': '' }

      expect(response.status).to eq(401)
      expect(JSON(response.body)['errors'].first).to eq('You need to sign in or sign up before continuing.')
    end
  end

  context 'create' do
    it 'should create a new content when user is logged in' do
      post '/api/v1/contents', 
        params: { content: { title: 'Newly created Content', body: 'body of content' } }.to_json,
        headers: { 'Content-Type': 'application/json',
                   'Authorization': auth_headers1['Authorization'] }

      expect(JSON(response.body)["data"]["attributes"]["title"]).to eq('Newly created Content')
      expect(user1.contents.count).to eq(2)
    end

    it 'should not create a new content when user is not signed in' do
      post '/api/v1/contents', 
        params: { content: { title: 'New Content', body: 'body of content' } }.to_json,
        headers: { 'Content-Type': 'application/json',
                   'Authorization': '' }

      expect(response.status).to eq(401)
      expect(JSON(response.body)["errors"].first).to eq("You need to sign in or sign up before continuing.")
    end
  end

  context 'update' do
    let!(:content) { create(:content, title: "New Content", user: user1) }

    it 'should update his/her own contents when user is logged in' do
      put "/api/v1/contents/#{content.id}", 
        params: { content: { title: 'Updated Content', body: 'Updated body of content' } }.to_json,
        headers: { 'Content-Type': 'application/json',
                   'Authorization': auth_headers1['Authorization'] }

      expect(response.status).to eq(200)
      expect(JSON(response.body)["data"]["attributes"]["title"]).to eq('Updated Content')
      expect(content.reload.title).to eq('Updated Content')
    end

    it 'should not update any of the content when user is not signed in' do
      put "/api/v1/contents/#{content.id}", 
        params: { content: { title: 'Updated Content', body: 'Updated body of content' } }.to_json,
        headers: { 'Content-Type': 'application/json',
                   'Authorization': '' }

      expect(response.status).to eq(401)
      expect(JSON(response.body)["errors"].first).to eq("You need to sign in or sign up before continuing.")
      expect(content.reload.title).to eq('New Content')
    end

    it 'should not update the contents of others despite logged in' do
      put "/api/v1/contents/#{content1.id}", 
        params: { content: { title: 'Updated Content', body: 'Updated body of content' } }.to_json,
        headers: { 'Content-Type': 'application/json',
                   'Authorization': auth_headers2['Authorization'] }

      expect(response.status).to eq(401)
      expect(JSON(response.body)["error"]).to eq("Unauthorized")
      expect(content.reload.title).to eq('New Content')
    end
  end

  context 'destroy' do
    let!(:content) { create(:content, title: "New Content", user: user1) }

    it 'should delete his/her own content when user is logged in' do
      delete "/api/v1/contents/#{content.id}", 
        headers: { 'Content-Type': 'application/json',
                   'Authorization': auth_headers1['Authorization'] }

      expect(response.status).to eq(200)
      expect(JSON(response.body)["message"]).to eq('Deleted')
      expect(Content.find_by(id: content.id)).to be_nil
    end

    it 'should not delete any of the content when user is not signed in' do
      delete "/api/v1/contents/#{content.id}", 
        headers: { 'Content-Type': 'application/json',
                   'Authorization': '' }

      expect(response.status).to eq(401)
      expect(JSON(response.body)["errors"].first).to eq("You need to sign in or sign up before continuing.")
      expect(Content.find_by(id: content.id)).not_to be_nil
    end

    it 'should not delete the contents of others despite logged in' do
      delete "/api/v1/contents/#{content1.id}", 
        headers: { 'Content-Type': 'application/json',
                   'Authorization': auth_headers2['Authorization'] }

      expect(response.status).to eq(401)
      expect(JSON(response.body)["error"]).to eq("Unauthorized")
      expect(Content.find_by(id: content1.id)).not_to be_nil
    end
  end
end
