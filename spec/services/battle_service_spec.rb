# frozen_string_literal: true
require 'rails_helper'

RSpec.describe BattleService do
  let(:fighter1) { create(:fighter, health_points: 100, attack_points: 15) }
  let(:fighter2) { create(:fighter, health_points: 100, attack_points: 15) }
  let(:weapon1) { create(:weapon, attack_bonus: 5) }
  let(:weapon2) { create(:weapon, attack_bonus: 5) }

  describe '#fight' do
    context 'when creating a battle' do
      it 'creates a battle record' do
        service = described_class.new(fighter1, fighter2)

        expect { service.fight }.to change(Battle, :count).by(1)
      end

      it 'sets winner and loser' do
        service = described_class.new(fighter1, fighter2)
        battle = service.fight

        expect([fighter1, fighter2]).to include(battle.winner)
        expect([fighter1, fighter2]).to include(battle.loser)
        expect(battle.winner).not_to eq(battle.loser)
      end

      it 'generates a battle log' do
        service = described_class.new(fighter1, fighter2)
        battle = service.fight

        expect(battle.battle_log).to include(battle.winner.name)
        expect(battle.battle_log).to include(battle.loser.name)
        expect(battle.battle_log).to include('Battle begins')
      end
    end

    context 'with weapons' do
      it 'includes weapon information in battle log' do
        service = described_class.new(fighter1, fighter2, weapon1, weapon2)
        battle = service.fight

        expect(battle.battle_log).to include(weapon1.name)
        expect(battle.battle_log).to include(weapon2.name)
      end

      it 'associates weapons with the battle' do
        service = described_class.new(fighter1, fighter2, weapon1, weapon2)
        battle = service.fight

        if battle.winner == fighter1
          expect(battle.winner_weapon).to eq(weapon1)
          expect(battle.loser_weapon).to eq(weapon2)
        else
          expect(battle.winner_weapon).to eq(weapon2)
          expect(battle.loser_weapon).to eq(weapon1)
        end
      end

      it 'includes weapon damage in battle log' do
        service = described_class.new(fighter1, fighter2, weapon1, weapon2)
        battle = service.fight

        expect(battle.battle_log).to match(/deals \d+ damage/)
      end
    end

    context 'when fighting' do
      it 'continues until one fighter reaches 0 HP' do
        service = described_class.new(fighter1, fighter2)
        battle = service.fight

        expect(battle.battle_log).to match(/0 HP/)
      end

      it 'alternates attacks between fighters' do
        fighter1 = create(:fighter, name: 'Alice')  # Explicit unique names
        fighter2 = create(:fighter, name: 'Bob')    # Explicit unique names

        service = described_class.new(fighter1, fighter2)
        battle = service.fight

        # Extract attack lines from battle log
        attack_lines = battle.battle_log.split("\n").select { |line| line.include?('deals') }

        # Check that consecutive attacks are from different fighters
        attack_lines.each_cons(2) do |attack1, attack2|
          attacker1 = attack1.split(' deals').first
          attacker2 = attack2.split(' deals').first
          expect(attacker1).not_to eq(attacker2)
        end
      end

      it 'determines winner based on remaining HP' do
        # Create an imbalanced fight
        strong_fighter = create(:fighter, health_points: 120, attack_points: 10)
        weak_fighter = create(:fighter, health_points: 50, attack_points: 10)

        service = described_class.new(strong_fighter, weak_fighter)
        battle = service.fight

        expect(battle.winner).to eq(strong_fighter)
        expect(battle.loser).to eq(weak_fighter)
      end
    end

    context 'with random elements' do
      it 'produces different outcomes for identical fighters' do
        # Run multiple battles with identical fighters
        battles = Array.new(10) do
          fighter1 = create(:fighter, health_points: 100, attack_points: 15)
          fighter2 = create(:fighter, health_points: 100, attack_points: 15)
          described_class.new(fighter1, fighter2).fight
        end

        # Check that we have some variation in winners
        winners = battles.map(&:winner)
        expect(winners.uniq.count).to be > 1
      end
    end

    context 'with incorrect fighters' do
      it 'raises error for invalid fighters' do
        expect do
          described_class.new(nil, fighter2).fight
        end.to raise_error(ArgumentError)
      end

      it 'raises error when same fighter battles themselves' do
        expect do
          described_class.new(fighter1, fighter1).fight
        end.to raise_error(ArgumentError, 'A fighter cannot battle themselves')
      end
    end
  end
end
