class ApiFootballService
  BASE_URL = "https://v3.football.api-sports.io/"
  API_KEY = ENV.fetch("API_FOOTBALL_KEY")

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
      url = BASE_URL + endpoint
      response = Faraday.get(url, params) do |req|
        req.headers["x-apisports-key"] = API_KEY
      end
      JSON.parse(response.body)["response"]
    rescue Faraday::Error => e
      Rails.logger.error("API-Football request failed: #{e.message}")
      []
    end
  end
end