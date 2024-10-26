# frozen_string_literal: true
class BattlesController < ApplicationController
  def new
    @fighters = Fighter.all
    @weapons = Weapon.all
    @battle = Battle.new
  end

  def create
    return handle_missing_fighters unless both_fighters_selected?
    return handle_same_fighter if same_fighter_selected?

    setup_battle
    process_battle
  rescue ActiveRecord::RecordNotFound
    redirect_to new_battle_path, alert: 'Invalid fighter or weapon selected'
  end

  def show
    @battle = Battle.find(params[:id])
  end

  def index
    @battles = Battle.order(created_at: :desc).includes(:winner, :loser, :winner_weapon, :loser_weapon)
  end

  private

  def both_fighters_selected?
    params[:fighter1_id].present? && params[:fighter2_id].present?
  end

  def handle_missing_fighters
    redirect_to new_battle_path, alert: 'Please select both fighters'
  end

  def same_fighter_selected?
    @fighter1 = Fighter.find(params[:fighter1_id])
    @fighter2 = Fighter.find(params[:fighter2_id])
    @fighter1 == @fighter2
  end

  def handle_same_fighter
    redirect_to new_battle_path, alert: 'Please select two different fighters'
  end

  def setup_battle
    @weapon1 = find_weapon(params[:fighter1_weapon_id])
    @weapon2 = find_weapon(params[:fighter2_weapon_id])
  end

  def find_weapon(weapon_id)
    weapon_id.present? ? Weapon.find(weapon_id) : nil
  end

  def process_battle
    battle_service = BattleService.new(@fighter1, @fighter2, @weapon1, @weapon2)
    @battle = battle_service.fight

    if @battle.persisted?
      redirect_to @battle, notice: 'Battle completed!'
    else
      load_form_data
      render :new
    end
  end

  def load_form_data
    @fighters = Fighter.all
    @weapons = Weapon.all
  end
end
