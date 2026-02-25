class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true

  has_many :user_teams
  def teams
    user_teams.pluck(:team_id)
  end
end
