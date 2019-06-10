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

ActiveRecord::Schema.define(version: 2019_06_10_214524) do

  create_table "common_names", force: :cascade do |t|
    t.integer "taxon_id", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "taxon_id"], name: "index_common_names_on_name_and_taxon_id", unique: true
    t.index ["taxon_id"], name: "index_common_names_on_taxon_id"
  end

  create_table "photos", force: :cascade do |t|
    t.integer "taxon_id", null: false
    t.string "image_path", null: false
    t.integer "seen", default: 0, null: false
    t.integer "correct", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["taxon_id"], name: "index_photos_on_taxon_id"
  end

  create_table "taxons", force: :cascade do |t|
    t.string "name"
    t.integer "taxon_id"
    t.integer "rank"
    t.integer "root_taxon_id"
    t.index ["taxon_id"], name: "index_taxons_on_taxon_id"
  end

  create_table "taxons_tier1s", id: false, force: :cascade do |t|
    t.integer "taxon_id", null: false
    t.integer "tier1_id", null: false
    t.index ["taxon_id", "tier1_id"], name: "index_taxons_tier1s_on_taxon_id_and_tier1_id", unique: true
  end

  create_table "taxons_tier2s", id: false, force: :cascade do |t|
    t.integer "taxon_id", null: false
    t.integer "tier2_id", null: false
    t.index ["taxon_id", "tier2_id"], name: "index_taxons_tier2s_on_taxon_id_and_tier2_id", unique: true
  end

  create_table "taxons_tier3s", id: false, force: :cascade do |t|
    t.integer "taxon_id", null: false
    t.integer "tier3_id", null: false
    t.index ["taxon_id", "tier3_id"], name: "index_taxons_tier3s_on_taxon_id_and_tier3_id", unique: true
  end

  create_table "tier1s", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tier2s", force: :cascade do |t|
    t.string "name"
    t.integer "tier1_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tier1_id"], name: "index_tier2s_on_tier1_id"
  end

  create_table "tier3s", force: :cascade do |t|
    t.string "name"
    t.integer "tier2_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tier2_id"], name: "index_tier3s_on_tier2_id"
  end

  create_table "user_taxon_data", force: :cascade do |t|
    t.integer "taxon_id", null: false
    t.integer "user_id", null: false
    t.bigint "seen", default: 0, null: false
    t.bigint "correct", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["taxon_id"], name: "index_user_taxon_data_on_taxon_id"
    t.index ["user_id", "taxon_id"], name: "index_user_taxon_data_on_user_id_and_taxon_id", unique: true
    t.index ["user_id"], name: "index_user_taxon_data_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "username"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
