# frozen_string_literal: true
class CreateBattles < ActiveRecord::Migration[7.0]
  def change
    create_table :battles do |t|
      t.references :winner, null: false, foreign_key: { to_table: :fighters }
      t.references :loser, null: false, foreign_key: { to_table: :fighters }
      t.references :winner_weapon, foreign_key: { to_table: :weapons }
      t.references :loser_weapon, foreign_key: { to_table: :weapons }
      t.text :battle_log

      t.timestamps
    end
  end
end
