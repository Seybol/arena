# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Fighter, type: :model do
  describe 'validations' do
    subject { build(:fighter) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
    it { is_expected.to validate_presence_of(:health_points) }
    it { is_expected.to validate_presence_of(:attack_points) }

    it { is_expected.to validate_numericality_of(:health_points).is_greater_than(0).is_less_than_or_equal_to(150) }
    it { is_expected.to validate_numericality_of(:attack_points).is_greater_than(0).is_less_than_or_equal_to(25) }
  end

  describe 'power balance' do
    it 'is invalid when total power exceeds maximum' do
      fighter = build(:fighter, health_points: 150, attack_points: 25)
      expect(fighter).not_to be_valid
      expect(fighter.errors[:base]).to include(
        'Fighter is too powerful! Total power (HP + (ATK * 5)) must not exceed 200'
      )
    end

    it 'is valid when total power is within limits' do
      fighter = build(:fighter, health_points: 100, attack_points: 15)
      expect(fighter).to be_valid
    end
  end

  describe 'battle statistics' do
    describe '#battle_count' do
      it 'returns the sum of victories and defeats' do
        fighter = create(:fighter)
        create_list(:battle, 3, winner: fighter)
        create_list(:battle, 2, loser: fighter)

        # Reload the fighter to get updated statistics
        fighter.reload
        expect(fighter.battle_count).to eq(5)
      end
    end

    describe '#win_rate' do
      it 'calculates correct win rate percentage' do
        fighter = create(:fighter)
        create_list(:battle, 6, winner: fighter)
        create_list(:battle, 4, loser: fighter)

        # Reload the fighter to get updated statistics
        fighter.reload
        expect(fighter.win_rate).to eq(60.0)
      end

      it 'returns 0 for fighters with no battles' do
        fighter = create(:fighter)
        expect(fighter.win_rate).to eq(0)
      end
    end
  end
end
