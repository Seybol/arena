# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Battle, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:battle_log) }

    describe 'fighters must be different' do
      let(:fighter) { create(:fighter) }
      let(:battle) { build(:battle) }

      it 'is invalid when winner and loser are the same fighter' do
        battle.winner = fighter
        battle.loser = fighter

        expect(battle).not_to be_valid
        expect(battle.errors[:base]).to include('A fighter cannot battle against themselves')
      end
    end
  end

  describe 'callbacks' do
    describe 'after creation' do
      let(:winner) { create(:fighter) }
      let(:loser) { create(:fighter) }

      it 'updates fighter statistics' do
        expect do
          create(:battle, winner: winner, loser: loser)
          winner.reload
          loser.reload
        end.to change(winner, :victories).by(1)
           .and change(loser, :defeats).by(1)
      end
    end
  end

  describe 'scopes' do
    describe '.recent' do
      it 'returns battles in descending order by creation date' do
        old_battle = create(:battle, created_at: 2.days.ago)
        new_battle = create(:battle, created_at: 1.day.ago)
        newest_battle = create(:battle, created_at: 1.hour.ago)

        expect(described_class.recent.limit(3)).to eq([newest_battle, new_battle, old_battle])
      end

      it 'limits the number of returned battles' do
        create_list(:battle, 10)
        expect(described_class.recent.count).to eq(5) # Assuming default limit is 5
      end
    end
  end

  describe 'battle creation' do
    let(:winner) { create(:fighter) }
    let(:loser) { create(:fighter) }
    let(:sword) { create(:weapon, :sword) }
    let(:axe) { create(:weapon, :axe) }

    it 'creates a battle with weapons' do
      battle = create(:battle,
                      winner: winner,
                      loser: loser,
                      winner_weapon: sword,
                      loser_weapon: axe)

      expect(battle).to be_valid
      expect(battle.winner_weapon).to eq(sword)
      expect(battle.loser_weapon).to eq(axe)
    end

    it 'creates a battle without weapons' do
      battle = create(:battle, winner: winner, loser: loser)

      expect(battle).to be_valid
      expect(battle.winner_weapon).to be_nil
      expect(battle.loser_weapon).to be_nil
    end

    it 'generates appropriate battle log' do
      battle = create(:battle, winner: winner, loser: loser)
      expect(battle.battle_log).to include(winner.name)
      expect(battle.battle_log).to include(loser.name)
    end
  end
end
