require 'rails_helper'

RSpec.describe User, type: :model do
  before(:each) do
    @user = FactoryBot.create(:user)
  end

  describe 'Validations' do
    it 'is valid with valid attributes' do
      expect(@user).to be_valid
    end

    it 'is invalid without a name' do
      @user.name = nil
      expect(@user).not_to be_valid
      expect(@user.errors[:name]).to include("can't be blank")
    end

    it 'is invalid without an email' do
      @user.email = nil
      expect(@user).not_to be_valid
      expect(@user.errors[:email]).to include("can't be blank")
    end

    it 'is invalid with duplicate email' do
      duplicate_user = FactoryBot.build(:user, email: @user.email)
      expect(duplicate_user).not_to be_valid
      expect(duplicate_user.errors[:email]).to include("has already been taken")
    end
  end

  describe 'Associations' do
    it 'has many user_teams' do
      assoc = described_class.reflect_on_association(:user_teams)
      expect(assoc.macro).to eq(:has_many)
    end
  end
end