require 'rails_helper'

RSpec.describe UserTeam, type: :model do
  before(:each) do
    @user = FactoryBot.create(:user)
    @user_team = FactoryBot.create(:user_team, user: @user, team_id: 1234)
  end

  describe 'Validations' do
    it 'is valid with valid attributes' do
      expect(@user_team).to be_valid
    end

    it 'is invalid without a team_id' do
      @user_team.team_id = nil
      expect(@user_team).not_to be_valid
      expect(@user_team.errors[:team_id]).to include("can't be blank")
    end

    it 'does not allow duplicate team_id for the same user' do
      duplicate = FactoryBot.build(:user_team, user: @user, team_id: @user_team.team_id)
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:team_id]).to include("ya seleccionado por este usuario")
    end
  end

  describe 'Associations' do
    it 'belongs to user' do
      assoc = described_class.reflect_on_association(:user)
      expect(assoc.macro).to eq(:belongs_to)
    end
  end
end