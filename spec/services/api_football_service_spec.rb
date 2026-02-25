require 'rails_helper'

RSpec.describe ApiFootballService do
  before(:each) do
    @team_id = 1
    @venue_id = 10
  end

  describe '.search_teams' do
    it 'devuelve equipos que coinciden con el nombre' do
      stub_request(:get, /teams/).to_return(
        status: 200,
        body: { "response": [{ "team": { "id" => @team_id, "name" => "Barcelona" } }] }.to_json
      )

      result = ApiFootballService.search_teams("Barcelona")
      expect(result.first["team"]["name"]).to eq("Barcelona")
    end
  end

  describe '.team_info' do
    it 'devuelve la información de un equipo por id' do
      stub_request(:get, /teams/).to_return(
        status: 200,
        body: { "response": [{ "team": { "id" => @team_id, "name" => "Barcelona", "founded" => 1899 } }] }.to_json
      )

      result = ApiFootballService.team_info(@team_id)
      expect(result.first["team"]["id"]).to eq(@team_id)
      expect(result.first["team"]["founded"]).to eq(1899)
    end
  end

  describe '.team_fixtures' do
    it 'devuelve fixtures de un equipo' do
      stub_request(:get, /fixtures/).to_return(
        status: 200,
        body: { "response": [{ "fixture": { "id" => 100, "date" => "2026-03-01T18:00:00+00:00" } }] }.to_json
      )

      result = ApiFootballService.team_fixtures(@team_id)
      expect(result.first["fixture"]["id"]).to eq(100)
      expect(result.first["fixture"]["date"]).to eq("2026-03-01T18:00:00+00:00")
    end
  end

  describe '.venue_info' do
    it 'devuelve información de un estadio por id' do
      stub_request(:get, /venues/).to_return(
        status: 200,
        body: { "response": [{ "venue": { "id" => @venue_id, "name" => "Camp Nou", "city" => "Barcelona" } }] }.to_json
      )

      result = ApiFootballService.venue_info(@venue_id)
      expect(result.first["venue"]["id"]).to eq(@venue_id)
      expect(result.first["venue"]["name"]).to eq("Camp Nou")
    end
  end
end