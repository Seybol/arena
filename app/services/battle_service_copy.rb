# frozen_string_literal: true
class BattleServiceCopy
  def initialize(fighter1, fighter2, weapon1 = nil, weapon2 = nil)
    @fighter1 = fighter1
    @fighter2 = fighter2
    @weapon1 = weapon1
    @weapon2 = weapon2
    @battle_log = []
    @hp1 = fighter1.health_points
    @hp2 = fighter2.health_points
  end

  def execute
    validate_fighters!
    log_battle_start
    conduct_battle
    record_battle
  end

  private

  def validate_fighters!
    raise ArgumentError, 'Fighters cannot be nil' if @fighter1.nil? || @fighter2.nil?
    raise ArgumentError, 'A fighter cannot battle themselves' if @fighter1 == @fighter2
  end

  def log_battle_start
    @battle_log << "Battle begins between #{@fighter1.name} and #{@fighter2.name}!"
    log_weapon(@fighter1, @weapon1)
    log_weapon(@fighter2, @weapon2)
  end

  def conduct_battle
    @current_attacker, @defender = select_first_attacker

    while both_fighters_alive?
      execute_attack_round
      switch_roles
    end
  end

  def select_first_attacker
    first = [@fighter1, @fighter2].sample
    second = first == @fighter1 ? @fighter2 : @fighter1
    [first, second]
  end

  def both_fighters_alive?
    @hp1.positive? && @hp2.positive?
  end

  def execute_attack_round
    damage = calculate_damage(@current_attacker, current_weapon)
    apply_damage(damage)
    log_attack(@current_attacker, @defender, damage, defender_hp)
  end

  def current_weapon
    @current_attacker == @fighter1 ? @weapon1 : @weapon2
  end

  def apply_damage(damage)
    if @current_attacker == @fighter1
      @hp2 -= damage
    else
      @hp1 -= damage
    end
  end

  def defender_hp
    @current_attacker == @fighter1 ? @hp2 : @hp1
  end

  def switch_roles
    @current_attacker, @defender = @defender, @current_attacker
  end

  def calculate_damage(attacker, weapon)
    base_damage = attacker.attack_points
    weapon_bonus = weapon&.attack_bonus || 0
    base_damage + weapon_bonus
  end

  def log_weapon(fighter, weapon)
    return unless weapon

    @battle_log << "#{fighter.name} wields #{weapon.name} (+#{weapon.attack_bonus} ATK)"
  end

  def log_attack(attacker, defender, damage, remaining_hp)
    @battle_log << "#{attacker.name} deals #{damage} damage to #{defender.name} (#{[remaining_hp, 0].max} HP remaining)"
  end

  def record_battle
    winner, loser = determine_winner_and_loser
    winner_weapon = winner == @fighter1 ? @weapon1 : @weapon2
    loser_weapon = loser == @fighter1 ? @weapon1 : @weapon2

    Battle.create!(
      winner: winner,
      loser: loser,
      winner_weapon: winner_weapon,
      loser_weapon: loser_weapon,
      battle_log: @battle_log.join("\n")
    )
  end

  def determine_winner_and_loser
    @hp1 > @hp2 ? [@fighter1, @fighter2] : [@fighter2, @fighter1]
  end
end
