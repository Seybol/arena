# frozen_string_literal: true
class Battle < ApplicationRecord
  belongs_to :winner, class_name: 'Fighter'
  belongs_to :loser, class_name: 'Fighter'
  belongs_to :winner_weapon, class_name: 'Weapon', optional: true
  belongs_to :loser_weapon, class_name: 'Weapon', optional: true

  validates :winner, :loser, :battle_log, presence: true
  validate :fighters_must_be_different

  scope :recent, -> { order(created_at: :desc).limit(5) }

  private

  def fighters_must_be_different
    return unless winner_id == loser_id

    errors.add(:base, 'A fighter cannot battle against themselves')
  end
end
