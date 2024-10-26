# frozen_string_literal: true
class Weapon < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :attack_bonus, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 10 }
end
