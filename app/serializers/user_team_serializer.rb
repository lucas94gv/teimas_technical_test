class UserTeamSerializer
  include FastJsonapi::ObjectSerializer

  attributes :id, :user_id, :team_id
end