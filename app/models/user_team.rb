class UserTeam < ApplicationRecord
  belongs_to :user

  validates :team_id, presence: true, uniqueness: { scope: :user_id, message: "ya seleccionado por este usuario" }
end