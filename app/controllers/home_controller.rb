# frozen_string_literal: true
class HomeController < ApplicationController
  def index
    @recent_battles = Battle.recent
                            .includes(:winner, :loser, :winner_weapon, :loser_weapon)
                            .limit(5)
  end
end
