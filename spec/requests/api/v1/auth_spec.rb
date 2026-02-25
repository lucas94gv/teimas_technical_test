require 'rails_helper'

RSpec.describe "Auth API", type: :request do
  before(:each) do
    @user = FactoryBot.create(:user, email: "test@example.com", password: "password123")
  end

  describe 'POST /api/v1/register' do
    it 'registers a new user successfully' do
      post '/api/v1/register', params: { name: "New User", email: "new@example.com", password: "123456", password_confirmation: "123456" }
      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)['token']).not_to be_nil
    end
  end

  describe 'POST /api/v1/login' do
    it 'logs in successfully with valid credentials' do
      post '/api/v1/login', params: { email: @user.email, password: "password123" }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['token']).not_to be_nil
    end
  end
end