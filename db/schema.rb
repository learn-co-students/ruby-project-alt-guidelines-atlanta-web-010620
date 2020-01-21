# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 4) do

  create_table "campaigns", force: :cascade do |t|
    t.string "dungeon_master"
    t.string "world"
    t.string "bbg"
    t.string "day_of_play"
    t.integer "max_players"
  end

  create_table "characters", force: :cascade do |t|
    t.string "name"
    t.string "character_class"
    t.string "race"
    t.integer "level"
    t.integer "armor_class"
    t.integer "current_health"
    t.integer "max_health"
    t.integer "strength"
    t.integer "dexterity"
    t.integer "wisdom"
    t.integer "intelligence"
    t.integer "charisma"
    t.integer "constitution"
    t.integer "player_id"
    t.integer "campaign_id"
  end

  create_table "players", force: :cascade do |t|
    t.string "name"
    t.string "availability"
  end

end
