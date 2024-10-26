# frozen_string_literal: true
class CreateFighters < ActiveRecord::Migration[7.0]
  def change
    create_table :fighters do |t|
      t.string :name, null: false
      t.integer :health_points, null: false, default: 100
      t.integer :attack_points, null: false, default: 10

      t.timestamps
    end

    add_index :fighters, :name, unique: true
  end
end
