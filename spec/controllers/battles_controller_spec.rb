# frozen_string_literal: true
require 'rails_helper'

RSpec.describe BattlesController, type: :controller do
  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end

    it 'orders battles by most recent first' do
      old_battle = create(:battle, created_at: 1.day.ago)
      new_battle = create(:battle, created_at: 1.hour.ago)

      get :index
      expect(controller.instance_variable_get(:@battles)).to eq([new_battle, old_battle])
    end
  end

  describe 'GET #show' do
    let(:battle) { create(:battle) }

    it 'returns a success response' do
      get :show, params: { id: battle.id }
      expect(response).to be_successful
    end

    it 'finds the requested battle' do
      get :show, params: { id: battle.id }
      expect(controller.instance_variable_get(:@battle)).to eq(battle)
    end
  end

  describe 'GET #new' do
    it 'returns a success response' do
      get :new
      expect(response).to be_successful
    end

    it 'loads all available fighters' do
      fighters = create_list(:fighter, 3)
      get :new
      expect(controller.instance_variable_get(:@fighters)).to match_array(fighters)
    end

    it 'loads all available weapons' do
      weapons = create_list(:weapon, 3)
      get :new
      expect(controller.instance_variable_get(:@weapons)).to match_array(weapons)
    end
  end

  describe 'POST #create' do
    let(:fighter1) { create(:fighter) }
    let(:fighter2) { create(:fighter) }
    let(:weapon1) { create(:weapon) }
    let(:weapon2) { create(:weapon) }

    context 'with valid parameters' do
      let(:valid_params) do
        {
          fighter1_id: fighter1.id,
          fighter2_id: fighter2.id,
          fighter1_weapon_id: weapon1.id,
          fighter2_weapon_id: weapon2.id
        }
      end

      it 'creates a new battle' do
        expect do
          post :create, params: valid_params
        end.to change(Battle, :count).by(1)
      end

      it 'redirects to the created battle' do
        post :create, params: valid_params
        expect(response).to redirect_to(Battle.last)
      end

      it 'sets a success notice' do
        post :create, params: valid_params
        expect(flash[:notice]).to eq('Battle completed!')
      end
    end

    context 'with invalid parameters' do
      it 'redirects to new battle path when fighters are not selected' do
        post :create, params: {}
        expect(response).to redirect_to(new_battle_path)
        expect(flash[:alert]).to eq('Please select both fighters')
      end

      it 'redirects when same fighter is selected twice' do
        post :create, params: { fighter1_id: fighter1.id, fighter2_id: fighter1.id }
        expect(response).to redirect_to(new_battle_path)
        expect(flash[:alert]).to eq('Please select two different fighters')
      end

      it 'handles invalid fighter IDs' do
        post :create, params: { fighter1_id: 999, fighter2_id: fighter2.id }
        expect(response).to redirect_to(new_battle_path)
        expect(flash[:alert]).to eq('Invalid fighter or weapon selected')
      end

      it 'handles invalid weapon IDs' do
        post :create, params: {
          fighter1_id: fighter1.id,
          fighter2_id: fighter2.id,
          fighter1_weapon_id: 999
        }
        expect(response).to redirect_to(new_battle_path)
        expect(flash[:alert]).to eq('Invalid fighter or weapon selected')
      end
    end
  end

  describe 'battle service integration' do
    let(:fighter1) { create(:fighter) }
    let(:fighter2) { create(:fighter) }

    it 'updates fighter statistics after battle' do
      post :create, params: {
        fighter1_id: fighter1.id,
        fighter2_id: fighter2.id
      }

      battle = Battle.last
      expect(battle.winner.victories).to eq(1)
      expect(battle.loser.defeats).to eq(1)
    end
  end
end
