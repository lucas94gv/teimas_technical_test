module Api::V1
  class TeamsController < ApplicationController
    before_action :authorize_request

    MAX_TEAMS = 5

    # GET /api/v1/teams/search?name=Barcelona
    def search
      name = params[:name]
      return render_error("Parameter 'name' is required") unless name.present?

      teams = ApiFootballService.search_teams(name)
      render_success(teams)
    rescue => e
      render_error(e.message)
    end

    # POST /api/v1/teams/select
    def select
      team_id = params[:team_id]
      return render_error("Parameter 'team_id' is required") unless team_id.present?

      if current_user.user_teams.count >= MAX_TEAMS
        return render_error("Maximum #{MAX_TEAMS} teams allowed", :unprocessable_entity)
      end

      user_team = current_user.user_teams.new(team_id: team_id)

      if user_team.save
        render_success(user_team)
      else
        render_error(user_team.errors.full_messages, :unprocessable_entity)
      end
    end

    # DELETE /api/v1/teams/deselect
    def deselect
      team_id = params[:team_id]
      return render_error("Parameter 'team_id' is required") unless team_id.present?

      user_team = current_user.user_teams.find_by(team_id: team_id)
      return render_error("Team not found", :not_found) unless user_team

      user_team.destroy
      render_success({ message: "Team deselected successfully" })
    end

    # GET /api/v1/teams
    def index
      render_success(current_user.user_teams)
    end

    def favorites
      team_ids = current_user.user_teams.pluck(:team_id)

      if team_ids.empty?
        render json: { success: true, data: [] }
        return
      end

      teams_data = team_ids.map do |id|
        response = ApiFootballService.team_info(id)
        next unless response.any?
        team = response[0]["team"]
        {
          id: team["id"],
          name: team["name"],
          logo: team["logo"],
          country: { name: team["country"] }
        }
      end.compact

      render json: { success: true, data: teams_data }
    end
  end
end