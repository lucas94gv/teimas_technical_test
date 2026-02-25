require 'rails_helper'

RSpec.describe "Auth API", type: :request do
  before(:each) do
    @user = FactoryBot.create(:user, email: "test@example.com", password: "password123")
  end

  describe 'POST /api/v1/register' do
    it 'registers a new user successfully' do
      post '/api/v1/register', params: { name: "New User", email: "new@example.com", password: "123456", password_confirmation: "123456" }
      expect(response).to have_http_status(:created)
      body = JSON.parse(response.body)
      expect(body['success']).to eq(true)
      expect(body['data']['token']).not_to be_nil
      expect(body['data']['user']['email']).to eq("new@example.com")
    end
  end

  describe 'POST /api/v1/login' do
    it 'logs in successfully with valid credentials' do
      post '/api/v1/login', params: { email: @user.email, password: "password123" }
      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body['success']).to eq(true)
      expect(body['data']['token']).not_to be_nil
      expect(body['data']['user']['email']).to eq(@user.email)
    end

    it 'returns unauthorized with invalid credentials' do
      post '/api/v1/login', params: { email: @user.email, password: "wrongpassword" }
      expect(response).to have_http_status(:unauthorized)
      body = JSON.parse(response.body)
      expect(body['success']).to eq(false)
      expect(body['errors']).to include("Invalid credentials")
    end
  end

  describe 'GET /api/v1/profile' do
    it 'returns unauthorized without token' do
      get '/api/v1/profile'
      expect(response).to have_http_status(:unauthorized)
      body = JSON.parse(response.body)
      expect(body['success']).to eq(false)
      expect(body['errors']).to include("Unauthorized")
    end

    it 'returns profile with valid token' do
      token = JsonWebToken.encode(user_id: @user.id)
      get '/api/v1/profile', headers: { "Authorization" => "Bearer #{token}" }
      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body['success']).to eq(true)
      expect(body['data']['id']).to eq(@user.id)
      expect(body['data']['email']).to eq(@user.email)
    end

    it 'returns unauthorized with invalid token' do
      get '/api/v1/profile', headers: { "Authorization" => "Bearer invalidtoken" }
      expect(response).to have_http_status(:unauthorized)
      body = JSON.parse(response.body)
      expect(body['success']).to eq(false)
      expect(body['errors']).to include("Unauthorized")
    end
  end
end
