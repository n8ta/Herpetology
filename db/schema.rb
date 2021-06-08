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

ActiveRecord::Schema.define(version: 2021_06_08_022640) do

  create_table "bad_id_reports", charset: "utf8", force: :cascade do |t|
    t.boolean "handled", default: false, null: false
    t.boolean "approved", default: false
    t.bigint "user_id"
    t.bigint "handled_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "taxon_id", null: false
    t.bigint "photo_id", null: false
    t.index ["photo_id"], name: "index_bad_id_reports_on_photo_id"
    t.index ["taxon_id"], name: "index_bad_id_reports_on_taxon_id"
    t.index ["user_id"], name: "fk_rails_00945fcad6"
  end

  create_table "bad_region_reports", charset: "utf8", force: :cascade do |t|
    t.boolean "handled", default: false, null: false
    t.boolean "approved", default: false
    t.bigint "user_id"
    t.bigint "handled_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "region_id", null: false
    t.bigint "taxon_id", null: false
    t.index ["region_id"], name: "index_bad_region_reports_on_region_id"
    t.index ["taxon_id"], name: "index_bad_region_reports_on_taxon_id"
    t.index ["user_id"], name: "fk_rails_c267bd0b27"
  end

  create_table "common_names", charset: "utf8", force: :cascade do |t|
    t.bigint "taxon_id", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "taxon_id"], name: "index_common_names_on_name_and_taxon_id", unique: true
    t.index ["taxon_id"], name: "index_common_names_on_taxon_id"
  end

  create_table "dead_herp_reports", charset: "utf8", force: :cascade do |t|
    t.boolean "handled", default: false, null: false
    t.boolean "approved", default: false
    t.bigint "user_id"
    t.bigint "handled_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "photo_id", null: false
    t.index ["photo_id"], name: "index_dead_herp_reports_on_photo_id"
    t.index ["user_id"], name: "fk_rails_a0317a615f"
  end

  create_table "groups", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "name"
  end

  create_table "groups_taxons", id: false, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "group_id", null: false
    t.bigint "taxon_id", null: false
  end

  create_table "messages", charset: "utf8", force: :cascade do |t|
    t.text "content", null: false
    t.bigint "report_id"
    t.bigint "src", null: false
    t.bigint "dst", null: false
    t.boolean "read", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dst"], name: "fk_rails_dafa164fa2"
    t.index ["report_id"], name: "index_messages_on_report_id"
    t.index ["src"], name: "fk_rails_8b62b3bab8"
  end

  create_table "no_herp_reports", charset: "utf8", force: :cascade do |t|
    t.boolean "handled", default: false, null: false
    t.boolean "approved", default: false
    t.bigint "user_id"
    t.bigint "handled_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "photo_id", null: false
    t.index ["photo_id"], name: "index_no_herp_reports_on_photo_id"
    t.index ["user_id"], name: "fk_rails_8501553af1"
  end

  create_table "photos", charset: "utf8", force: :cascade do |t|
    t.bigint "taxon_id", null: false
    t.string "image_path", null: false
    t.bigint "seen", default: 0, null: false
    t.bigint "correct", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "dead", default: false
    t.boolean "hidden", default: false, null: false
    t.index ["taxon_id"], name: "index_photos_on_taxon_id"
  end

  create_table "regions", charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.bigint "region_id"
    t.index ["region_id"], name: "index_regions_on_region_id"
  end

  create_table "regions_root_taxons", charset: "utf8", force: :cascade do |t|
    t.bigint "region_id"
    t.bigint "taxon_id"
    t.index ["region_id"], name: "index_regions_root_taxons_on_region_id"
    t.index ["taxon_id", "region_id"], name: "index_regions_root_taxons_on_taxon_id_and_region_id", unique: true
    t.index ["taxon_id"], name: "index_regions_root_taxons_on_taxon_id"
  end

  create_table "regions_taxons", id: false, charset: "utf8", force: :cascade do |t|
    t.bigint "region_id", null: false
    t.bigint "taxon_id", null: false
    t.index ["region_id"], name: "fk_rails_fa98b95512"
    t.index ["taxon_id", "region_id"], name: "index_regions_taxons_on_taxon_id_and_region_id", unique: true
  end

  create_table "taxons", charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.bigint "taxon_id"
    t.integer "rank"
    t.bigint "root_taxon_id"
    t.boolean "photographed", default: false, null: false
    t.string "photo"
    t.boolean "venomous"
    t.string "common_name"
    t.index ["root_taxon_id"], name: "fk_rails_795ac0b1ff"
    t.index ["taxon_id"], name: "index_taxons_on_taxon_id"
  end

  create_table "tips", charset: "utf8", force: :cascade do |t|
    t.bigint "user_id"
    t.text "content"
    t.bigint "taxon_id"
    t.boolean "approved", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "handled", default: false
    t.index ["taxon_id"], name: "index_tips_on_taxon_id"
    t.index ["user_id"], name: "index_tips_on_user_id"
  end

  create_table "user_taxon_data", charset: "utf8", force: :cascade do |t|
    t.bigint "taxon_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "sci_seen", default: 0, null: false
    t.bigint "sci_correct", default: 0, null: false
    t.bigint "common_seen", default: 0, null: false
    t.bigint "common_correct", default: 0, null: false
    t.index ["taxon_id"], name: "index_user_taxon_data_on_taxon_id"
    t.index ["user_id", "taxon_id"], name: "index_user_taxon_data_on_user_id_and_taxon_id", unique: true
    t.index ["user_id"], name: "index_user_taxon_data_on_user_id"
  end

  create_table "users", charset: "utf8", force: :cascade do |t|
    t.string "email"
    t.string "encrypted_password", default: ""
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "username"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_class"
    t.boolean "show_dead_photos", default: false
    t.boolean "google_user", default: false
    t.boolean "opt_out_of_email", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "venom_reports", charset: "utf8", force: :cascade do |t|
    t.boolean "handled", default: false, null: false
    t.boolean "approved", default: false
    t.bigint "user_id"
    t.bigint "handled_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "taxon_id", null: false
    t.integer "venomous", null: false
    t.index ["taxon_id"], name: "index_venom_reports_on_taxon_id"
    t.index ["user_id"], name: "fk_rails_81f394b198"
  end

  add_foreign_key "bad_id_reports", "photos"
  add_foreign_key "bad_id_reports", "taxons"
  add_foreign_key "bad_id_reports", "users"
  add_foreign_key "bad_region_reports", "regions"
  add_foreign_key "bad_region_reports", "taxons"
  add_foreign_key "bad_region_reports", "users"
  add_foreign_key "common_names", "taxons"
  add_foreign_key "dead_herp_reports", "photos"
  add_foreign_key "dead_herp_reports", "users"
  add_foreign_key "messages", "users", column: "dst"
  add_foreign_key "messages", "users", column: "src"
  add_foreign_key "no_herp_reports", "photos"
  add_foreign_key "no_herp_reports", "users"
  add_foreign_key "photos", "taxons"
  add_foreign_key "regions_root_taxons", "regions"
  add_foreign_key "regions_root_taxons", "taxons"
  add_foreign_key "regions_taxons", "regions"
  add_foreign_key "regions_taxons", "taxons"
  add_foreign_key "taxons", "taxons"
  add_foreign_key "taxons", "taxons", column: "root_taxon_id"
  add_foreign_key "tips", "taxons"
  add_foreign_key "tips", "users"
  add_foreign_key "user_taxon_data", "taxons"
  add_foreign_key "user_taxon_data", "users"
  add_foreign_key "venom_reports", "taxons"
  add_foreign_key "venom_reports", "users"
end
