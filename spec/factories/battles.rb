# frozen_string_literal: true
FactoryBot.define do
  factory :battle do
    association :winner, factory: :fighter
    association :loser, factory: :fighter
    winner_weapon { nil }
    loser_weapon { nil }
    battle_log { "#{winner.name} defeats #{loser.name} in an epic battle!" }

    trait :with_weapons do
      after(:build) do |battle|
        battle.winner_weapon = create(:weapon)
        battle.loser_weapon = create(:weapon)
      end
    end
  end
end
