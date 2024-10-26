# frozen_string_literal: true
class CreateWeapons < ActiveRecord::Migration[7.0]
  def change
    create_table :weapons do |t|
      t.string :name, null: false
      t.integer :attack_bonus, default: 0
      t.text :description

      t.timestamps
    end

    add_index :weapons, :name, unique: true
  end
end
