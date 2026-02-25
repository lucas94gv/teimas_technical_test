class UserSerializer
  include FastJsonapi::ObjectSerializer

  attributes :id, :name, :email

  attribute :teams do |user|
    user.user_teams.pluck(:team_id)
  end
end