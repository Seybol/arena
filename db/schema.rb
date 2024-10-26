# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2024_10_25_173855) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "battles", force: :cascade do |t|
    t.bigint "winner_id", null: false
    t.bigint "loser_id", null: false
    t.bigint "winner_weapon_id"
    t.bigint "loser_weapon_id"
    t.text "battle_log"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["loser_id"], name: "index_battles_on_loser_id"
    t.index ["loser_weapon_id"], name: "index_battles_on_loser_weapon_id"
    t.index ["winner_id"], name: "index_battles_on_winner_id"
    t.index ["winner_weapon_id"], name: "index_battles_on_winner_weapon_id"
  end

  create_table "fighters", force: :cascade do |t|
    t.string "name", null: false
    t.integer "health_points", default: 100, null: false
    t.integer "attack_points", default: 10, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_fighters_on_name", unique: true
  end

  create_table "weapons", force: :cascade do |t|
    t.string "name", null: false
    t.integer "attack_bonus", default: 0
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_weapons_on_name", unique: true
  end

  add_foreign_key "battles", "fighters", column: "loser_id"
  add_foreign_key "battles", "fighters", column: "winner_id"
  add_foreign_key "battles", "weapons", column: "loser_weapon_id"
  add_foreign_key "battles", "weapons", column: "winner_weapon_id"
end
