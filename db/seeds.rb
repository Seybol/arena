# frozen_string_literal: true
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# First, clear existing data
Rails.logger.debug 'Cleaning database...'
Battle.destroy_all
Fighter.destroy_all
Weapon.destroy_all

# Create Weapons
Rails.logger.debug 'Creating weapons...'
Weapon.create!(
  name: 'Basic Sword',
  attack_bonus: 5,
  description: 'A simple but reliable sword'
)

Weapon.create!(
  name: 'Battle Axe',
  attack_bonus: 8,
  description: 'A heavy axe that deals massive damage'
)

Weapon.create!(
  name: 'Spear',
  attack_bonus: 6,
  description: 'A long weapon with good reach'
)

Weapon.create!(
  name: 'War Hammer',
  attack_bonus: 7,
  description: 'A crushing weapon that can break armor'
)

Weapon.create!(
  name: 'Daggers',
  attack_bonus: 4,
  description: 'Quick dual-wielded blades for swift strikes'
)

Weapon.create!(
  name: 'Great Sword',
  attack_bonus: 9,
  description: 'A massive two-handed sword with devastating power'
)

# Create Fighters
Rails.logger.debug 'Creating fighters...'

Fighter.create!(
  name: 'Leonidas',
  health_points: 120,
  attack_points: 12
)

Fighter.create!(
  name: 'Achilles',
  health_points: 110,
  attack_points: 15
)

Fighter.create!(
  name: 'Miyamoto Musashi',
  health_points: 100,
  attack_points: 14
)

Rails.logger.debug 'Seeding completed!'
