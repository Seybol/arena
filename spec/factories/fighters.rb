# frozen_string_literal: true
FactoryBot.define do
  factory :fighter do
    sequence(:name) { |n| "Warrior #{n}" }
    health_points { 100 }
    attack_points { 15 }
  end
end
