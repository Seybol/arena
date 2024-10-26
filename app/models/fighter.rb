# frozen_string_literal: true
class Fighter < ApplicationRecord
  has_many :won_battles,
           class_name: 'Battle',
           foreign_key: 'winner_id',
           inverse_of: :winner,
           dependent: :restrict_with_error

  has_many :lost_battles,
           class_name: 'Battle',
           foreign_key: 'loser_id',
           inverse_of: :loser,
           dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: true
  validates :health_points, presence: true,
                            numericality: { greater_than: 0, less_than_or_equal_to: 150 }
  validates :attack_points, presence: true,
                            numericality: { greater_than: 0, less_than_or_equal_to: 25 }

  validate :balanced_stats

  def battle_count
    won_battles.count + lost_battles.count
  end

  def victories
    won_battles.count
  end

  def defeats
    lost_battles.count
  end

  def win_rate
    return 0 if battle_count.zero?

    (victories.to_f / battle_count * 100).round(1)
  end

  private

  def balanced_stats
    return unless health_points && attack_points

    total_points = health_points + (attack_points * 5)
    max_total_points = 200

    return unless total_points > max_total_points

    errors.add(:base, 'Fighter is too powerful! Total power (HP + (ATK * 5)) must not exceed 200')
  end
end
