# frozen_string_literal: true
FactoryBot.define do
  factory :weapon do
    sequence(:name) { |n| "Weapon #{n}" }
    attack_bonus { rand(1..10) }
    description { 'A powerful weapon' }

    trait :sword do
      name { 'Sword' }
      attack_bonus { 5 }
      description { 'A balanced weapon' }
    end

    trait :axe do
      name { 'Battle Axe' }
      attack_bonus { 8 }
      description { 'A heavy hitting weapon' }
    end

    trait :dagger do
      name { 'Dagger' }
      attack_bonus { 3 }
      description { 'A quick weapon' }
    end
  end
end
