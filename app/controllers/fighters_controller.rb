# frozen_string_literal: true
class FightersController < ApplicationController
  before_action :set_fighter, only: %i[show edit update destroy]

  def index
    @fighters = Fighter.all
  end

  def show; end

  def new
    @fighter = Fighter.new
  end

  def create
    @fighter = Fighter.new(fighter_params)

    if @fighter.save
      redirect_to @fighter, notice: 'Fighter was successfully created.'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @fighter.update(fighter_params)
      redirect_to @fighter, notice: 'Fighter was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    if @fighter.won_battles.exists? || @fighter.lost_battles.exists?
      redirect_to fighters_path, alert: 'Cannot delete fighter with battle history'
    else
      @fighter.destroy
      redirect_to fighters_path, notice: 'Fighter was successfully destroyed.'
    end
  end

  private

  def set_fighter
    @fighter = Fighter.find(params[:id])
  end

  def fighter_params
    params.require(:fighter).permit(:name, :health_points, :attack_points)
  end
end
