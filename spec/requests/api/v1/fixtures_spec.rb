require 'rails_helper'

RSpec.describe "Fixtures API", type: :request do
  before(:each) do
    @user = FactoryBot.create(:user)
    @token = JsonWebToken.encode(user_id: @user.id)
    @headers = { "Authorization" => "Bearer #{@token}" }

    @user_team = FactoryBot.create(:user_team, user: @user, team_id: 1)
  end

  describe 'GET /api/v1/fixtures' do
    it 'devuelve los próximos partidos de los equipos favoritos' do
      allow(ApiFootballService).to receive(:team_fixtures).and_return([
                                                                        {
                                                                          "fixture" => { "id" => 10, "date" => "2026-03-01T18:00:00+00:00" },
                                                                          "teams" => { "home" => { "name" => "Barcelona" }, "away" => { "name" => "Real Madrid" } },
                                                                          "league" => { "name" => "La Liga" }
                                                                        }
                                                                      ])

      get '/api/v1/fixtures', headers: @headers

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body["success"]).to eq(true)
      expect(body["data"].first["fixture"]["id"]).to eq(10)
    end
  end
end