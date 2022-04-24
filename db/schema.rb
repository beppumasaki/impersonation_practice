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

ActiveRecord::Schema.define(version: 2022_04_24_223601) do

  create_table "collaborations", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.string "collaboration_voice", null: false
    t.integer "state", default: 0, null: false
    t.integer "user_id", null: false
    t.integer "result_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["result_id"], name: "index_collaborations_on_result_id"
    t.index ["user_id"], name: "index_collaborations_on_user_id"
  end

  create_table "comments", force: :cascade do |t|
    t.text "body"
    t.integer "user_id", null: false
    t.integer "result_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["result_id"], name: "index_comments_on_result_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "results", force: :cascade do |t|
    t.string "impersonation_voice", null: false
    t.integer "score", null: false
    t.text "body"
    t.integer "target_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "match_target"
    t.integer "user_id", default: 1, null: false
    t.integer "state", default: 0, null: false
    t.index ["target_id"], name: "index_results_on_target_id"
    t.index ["user_id"], name: "index_results_on_user_id"
  end

  create_table "targets", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "target_voice"
    t.string "profile_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "crypted_password"
    t.string "salt"
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "role", default: 0, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "votes", force: :cascade do |t|
    t.string "name", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_votes_on_user_id"
  end

  add_foreign_key "collaborations", "results"
  add_foreign_key "collaborations", "users"
  add_foreign_key "comments", "results"
  add_foreign_key "comments", "users"
  add_foreign_key "results", "targets"
  add_foreign_key "results", "users"
  add_foreign_key "votes", "users"
end
