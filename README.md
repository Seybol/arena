# Arena Battle Game

A Rails application where fighters can battle in an arena, using weapons and their unique stats to determine the winner.

## Features

- Create and manage fighters with balanced stats (HP and Attack points)
- Equip fighters with various weapons that provide attack bonuses
- Simulate battles with turn-based combat and detailed battle logs
- Track battle history and fighter statistics

## Tech Stack

- Ruby 3.2.2
- Rails 7.0.6
- PostgreSQL
- RSpec for testing
- Bootstrap 5 for styling
- Docker for containerization

## Quick Start with Docker

After cloning the repository, run `docker compose up` to start the application.

Visit `http://localhost:3000` and you are ready to fight !

## Launching the application without Docker

After cloning the repository, run `bundle install` to install the dependencies.

`yarn install` to install the JavaScript dependencies.

Then, run `rails db:setup` to create the database and seed the data.

Finally, run `rails server` to start the application.

Visit `http://localhost:3000` in your browser to enter the arena !

## Testing

Run `bundle exec rspec` to run the tests.

## 📖 Game Rules

1. **Fighter Creation**

   - Health Points (HP): 1-150
   - Attack Points (ATK): 1-25
   - Total power (HP + ATK\*5) must not exceed 200

2. **Weapons**

   - Attack bonus: 0-10
   - Optional equipment
   - Can be changed between battles

3. **Battle System**
   - Turn-based combat
   - Random first attacker
   - Battle continues until one fighter reaches 0 HP
   - Detailed battle log recorded
