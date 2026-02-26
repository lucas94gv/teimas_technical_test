require 'rails_helper'

RSpec.describe "Teams API", type: :request do
  before(:each) do
    @user = FactoryBot.create(:user)
    @token = JsonWebToken.encode(user_id: @user.id)
    @headers = { "Authorization" => "Bearer #{@token}" }
  end

  describe 'GET /api/v1/teams/search' do
    it 'busca equipos por nombre' do
      stub_request(:get, /teams/).to_return(
        status: 200,
        body: { "response": [{ "team": { "id" => 1, "name" => "Barcelona" } }] }.to_json
      )

      get '/api/v1/teams/search', params: { name: "Barcelona" }, headers: @headers
      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body["success"]).to eq(true)
      expect(body["data"].first["team"]["name"]).to eq("Barcelona")
    end
  end

  describe 'POST /api/v1/teams/select' do
    it 'selecciona un equipo favorito del usuario' do
      post '/api/v1/teams/select', params: { team_id: 1 }, headers: @headers
      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body["success"]).to eq(true)
      expect(body["data"]["team_id"]).to eq(1)
    end
  end

  describe 'DELETE /api/v1/teams/deselect' do
    it 'deselecciona un equipo favorito' do
      FactoryBot.create(:user_team, user: @user, team_id: 1)
      delete '/api/v1/teams/deselect', params: { team_id: 1 }, headers: @headers
      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body["success"]).to eq(true)
    end
  end

  describe 'GET /api/v1/teams' do
    it 'lista los equipos favoritos del usuario' do
      FactoryBot.create(:user_team, user: @user, team_id: 1)
      get '/api/v1/teams', headers: @headers
      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body["success"]).to eq(true)
      expect(body["data"].first["team_id"]).to eq(1)
    end
  end

  it 'devuelve array vacío si no tiene favoritos' do
    get '/api/v1/favorites', headers: @headers

    expect(response).to have_http_status(:ok)
    body = JSON.parse(response.body)

    expect(body["success"]).to eq(true)
    expect(body["data"]).to eq([])
  end

  it 'devuelve los equipos favoritos con información completa' do
    FactoryBot.create(:user_team, user: @user, team_id: 529)

    stub_request(:get, /teams/)
      .to_return(
        status: 200,
        body: {
          "response": [
            {
              "team": {
                "id" => 529,
                "name" => "Barcelona",
                "country" => "Spain",
                "logo" => "https://..."
              }
            }
          ]
        }.to_json
      )

    get '/api/v1/favorites', headers: @headers
    expect(response).to have_http_status(:ok)
    body = JSON.parse(response.body)
    expect(body["success"]).to eq(true)
    expect(body["data"].length).to eq(1)
    expect(body["data"].first["id"]).to eq(529)
    expect(body["data"].first["name"]).to eq("Barcelona")
  end
end