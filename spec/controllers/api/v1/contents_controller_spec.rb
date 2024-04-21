# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Contents API', type: :request do
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let!(:content1) { create(:content, user: user1) }
  let!(:content2) { create(:content, user: user2) }
  let(:auth_headers1) { user1.create_new_auth_token }
  let(:auth_headers2) { user2.create_new_auth_token }

  context 'when user is logged in' do
    it 'allows logged in user to view all the contents present' do
      get '/api/v1/contents',
          headers: { 'Content-Type': 'application/json',
                     'Authorization': auth_headers1['Authorization'] }

      expect(response.status).to eq(200)
      expect(JSON(response.body)['data'].count).to eq(2)
    end

    it 'allows logged in user to create a new content' do
      post '/api/v1/contents',
           params: { content: { title: 'Newly created Content', body: 'body of content' } }.to_json,
           headers: { 'Content-Type': 'application/json',
                      'Authorization': auth_headers1['Authorization'] }

      expect(JSON(response.body)['data']['attributes']['title']).to eq('Newly created Content')
      expect(user1.contents.count).to eq(2)
    end

    it 'allows logged in user to update his/her own contents' do
      put "/api/v1/contents/#{content1.id}",
          params: { content: { title: 'Updated Content', body: 'Updated body of content' } }.to_json,
          headers: { 'Content-Type': 'application/json',
                     'Authorization': auth_headers1['Authorization'] }

      expect(response.status).to eq(200)
      expect(JSON(response.body)['data']['attributes']['title']).to eq('Updated Content')
      expect(content1.reload.title).to eq('Updated Content')
    end

    it 'should not update the content when title or body is nil' do
      put "/api/v1/contents/#{content1.id}",
          params: { content: { title: 'Updated Content', body: '' } }.to_json,
          headers: { 'Content-Type': 'application/json',
                     'Authorization': auth_headers1['Authorization'] }

      expect(JSON(response.body)["body"].first).to eq("can't be blank")
    end

    it 'should not update the contents created by other users' do
      content_title = content1.title
      put "/api/v1/contents/#{content1.id}",
          params: { content: { title: 'Updated Content', body: 'Updated body of content' } }.to_json,
          headers: { 'Content-Type': 'application/json',
                     'Authorization': auth_headers2['Authorization'] }

      expect(response.status).to eq(401)
      expect(JSON(response.body)['error']).to eq('Unauthorized')
      expect(content1.reload.title).to eq(content_title)
    end

    it 'should delete his/her own content' do
      delete "/api/v1/contents/#{content1.id}",
             headers: { 'Content-Type': 'application/json',
                        'Authorization': auth_headers1['Authorization'] }

      expect(response.status).to eq(200)
      expect(JSON(response.body)['message']).to eq('Deleted')
      expect(Content.find_by(id: content1.id)).to be_nil
    end

    it 'should not delete the contents created by other users' do
      delete "/api/v1/contents/#{content1.id}",
             headers: { 'Content-Type': 'application/json',
                        'Authorization': auth_headers2['Authorization'] }

      expect(response.status).to eq(401)
      expect(JSON(response.body)['error']).to eq('Unauthorized')
      expect(Content.find_by(id: content1.id)).not_to be_nil
    end
  end

  context 'when user is not logged in' do
    it 'does not allow not signed in user to view contents' do
      get '/api/v1/contents',
          headers: { 'Content-Type': 'application/json',
                     'Authorization': '' }

      expect(response.status).to eq(401)
      expect(JSON(response.body)['errors'].first).to eq('You need to sign in or sign up before continuing.')
    end

    it 'does not allow not signed in user to create a new content' do
      post '/api/v1/contents',
           params: { content: { title: 'New Content', body: 'body of content' } }.to_json,
           headers: { 'Content-Type': 'application/json',
                      'Authorization': '' }

      expect(response.status).to eq(401)
      expect(JSON(response.body)['errors'].first).to eq('You need to sign in or sign up before continuing.')
    end

    it 'does not allow not signed in user to update any content' do
      put "/api/v1/contents/#{content1.id}",
          params: { content: { title: 'Updated Content', body: 'Updated body of content' } }.to_json,
          headers: { 'Content-Type': 'application/json',
                     'Authorization': '' }

      expect(response.status).to eq(401)
      expect(JSON(response.body)['errors'].first).to eq('You need to sign in or sign up before continuing.')
      expect(content1.reload.title).not_to eq('Updated Content')
    end

    it 'does not allow to delete any content' do
      delete "/api/v1/contents/#{content1.id}",
             headers: { 'Content-Type': 'application/json',
                        'Authorization': '' }

      expect(response.status).to eq(401)
      expect(JSON(response.body)['errors'].first).to eq('You need to sign in or sign up before continuing.')
      expect(Content.find_by(id: content1.id)).not_to be_nil
    end
  end
end

