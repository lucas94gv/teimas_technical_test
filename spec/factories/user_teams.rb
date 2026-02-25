FactoryBot.define do
  factory :user_team do
    association :user
    team_id { Faker::Number.between(from: 1, to: 1000) }
  end
end