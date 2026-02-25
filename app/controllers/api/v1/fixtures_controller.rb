module Api::V1
  class FixturesController < ApplicationController
    before_action :authorize_request

    # GET /api/v1/fixtures
    def index
      team_ids = current_user.user_teams.pluck(:team_id)
      fixtures = team_ids.flat_map do |team_id|
        ApiFootballService.team_fixtures(team_id, timezone: 'Europe/London', season: 2024)
      end

      fixtures.sort_by! { |f| f["fixture"]["date"] }

      render_success(fixtures)
    rescue => e
      render_error(e.message)
    end
  end
end