# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150415162702) do

  create_table "games", force: :cascade do |t|
    t.string   "game_name"
    t.string   "platform"
    t.string   "bundle_id"
    t.boolean  "in_db"
    t.string   "english_vid"
    t.string   "portrait"
    t.string   "landscape"
    t.string   "square_banner"
    t.string   "flat_banner"
    t.string   "english_promo"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

end
