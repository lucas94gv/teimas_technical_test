class ApiFootballService
  BASE_URL = "https://v3.football.api-sports.io/"
  API_KEY = ENV.fetch("API_FOOTBALL_KEY", nil)
  USE_MOCK = ENV["USE_MOCK"] == "true"

  class << self
    def search_teams(name)
      get("teams", { search: name })
    end

    def team_info(team_id)
      get("teams", { id: team_id })
    end

    def team_fixtures(team_id, options = {})
      get("fixtures", { team: team_id }.merge(options))
    end

    def venue_info(venue_id)
      get("venues", { id: venue_id })
    end

    private

    def get(endpoint, params = {})
      if USE_MOCK
        return mock_get(endpoint, params)
      end

      url = BASE_URL + endpoint

      response = Faraday.get(url, params) do |req|
        req.headers["x-apisports-key"] = API_KEY
      end

      JSON.parse(response.body)["response"]
    rescue Faraday::Error => e
      Rails.logger.error("API-Football request failed: #{e.message}")
      []
    end

    def mock_get(endpoint, params)
      file_path = Rails.root.join("lib", "mocks", "#{endpoint}.json")

      return [] unless File.exist?(file_path)

      json = JSON.parse(File.read(file_path))
      data = json["data"] || []

      case endpoint
      when "teams"
        if params[:search]
          data.select do |t|
            t["team"]["name"].downcase.include?(params[:search].downcase)
          end
        elsif params[:id]
          data.select do |t|
            t["team"]["id"].to_s == params[:id].to_s
          end
        else
          data
        end

      when "fixtures"
        if params[:team]
          data.select do |f|
            f["teams"]["home"]["id"].to_s == params[:team].to_s ||
              f["teams"]["away"]["id"].to_s == params[:team].to_s
          end
        else
          data
        end

      when "venues"
        if params[:id]
          data.map { |t| t["venue"] }
              .compact
              .select { |v| v["id"].to_s == params[:id].to_s }
        else
          []
        end

      else
        []
      end
    end
  end
end