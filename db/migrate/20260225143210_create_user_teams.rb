class CreateUserTeams < ActiveRecord::Migration[8.1]
  def up
    create_table :user_teams, id: :uuid do |t|
      t.uuid :user_id, null: false
      t.integer :team_id, null: false
      t.timestamps
    end

    add_index :user_teams, [:user_id, :team_id], unique: true
    add_foreign_key :user_teams, :users
  end

  def down
    remove_foreign_key :user_teams, :users
    drop_table :user_teams
  end
end
