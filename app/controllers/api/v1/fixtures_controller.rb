module Api::V1
  class FixturesController < ApplicationController
    before_action :authorize_request

    # GET /api/v1/fixtures?team_id=529
    def index
      team_ids = if params[:team_id].present?
                   [params[:team_id].to_i]
                 else
                   current_user.user_teams.pluck(:team_id)
                 end

      fixtures = team_ids.flat_map do |team_id|
        ApiFootballService.team_fixtures(team_id, timezone: 'Europe/London', season: 2024)
      end.uniq { |f| f["fixture"]["id"] }

      fixtures.sort_by! { |f| f["fixture"]["date"] }

      render_success(fixtures)
    rescue => e
      render_error(e.message)
    end
  end
end