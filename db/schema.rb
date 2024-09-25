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

ActiveRecord::Schema[7.0].define(version: 2024_09_24_035915) do
  create_table "accounts", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.decimal "balance", precision: 10
    t.bigint "currency_id", null: false
    t.bigint "user_id", null: false
    t.string "account_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["currency_id"], name: "index_accounts_on_currency_id"
    t.index ["user_id"], name: "index_accounts_on_user_id"
  end

  create_table "config_sets", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "configs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "config_set_id", null: false
    t.string "key"
    t.string "value"
    t.boolean "enable"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["config_set_id"], name: "index_configs_on_config_set_id"
    t.index ["key"], name: "index_configs_on_key"
  end

  create_table "currencies", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "symbol"
    t.string "code"
    t.boolean "isCrypto"
    t.boolean "enable"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_currencies_on_code", unique: true
  end

  create_table "devise_api_tokens", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "resource_owner_type", null: false
    t.bigint "resource_owner_id", null: false
    t.string "access_token", null: false
    t.string "refresh_token"
    t.integer "expires_in", null: false
    t.datetime "revoked_at"
    t.string "previous_refresh_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["access_token"], name: "index_devise_api_tokens_on_access_token"
    t.index ["previous_refresh_token"], name: "index_devise_api_tokens_on_previous_refresh_token"
    t.index ["refresh_token"], name: "index_devise_api_tokens_on_refresh_token"
    t.index ["resource_owner_type", "resource_owner_id"], name: "index_devise_api_tokens_on_resource_owner"
  end

  create_table "doc_types", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.string "category"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "docs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "doc_type_id", null: false
    t.string "action"
    t.string "status"
    t.bigint "user_id", null: false
    t.string "auth_code"
    t.string "ext_id"
    t.string "comment"
    t.string "source"
    t.integer "source_id"
    t.decimal "amount", precision: 10
    t.bigint "currency_id", null: false
    t.datetime "approved_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["currency_id"], name: "index_docs_on_currency_id"
    t.index ["doc_type_id"], name: "index_docs_on_doc_type_id"
    t.index ["user_id"], name: "index_docs_on_user_id"
  end

  create_table "lotto_inst", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "lotto_schema_id", null: false
    t.string "inst_hash"
    t.string "sand"
    t.string "prize"
    t.string "status"
    t.datetime "end_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "current_pot", precision: 15, scale: 8
    t.index ["lotto_schema_id"], name: "index_lotto_inst_on_lotto_schema_id"
  end

  create_table "lotto_prizes", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.integer "prize_length"
    t.integer "fill"
    t.integer "ordering"
    t.decimal "prize_value", precision: 15, scale: 8
    t.string "prize_type"
    t.boolean "enable"
    t.boolean "end_round"
    t.boolean "distribute"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "lotto_schema_id", null: false
    t.index ["code"], name: "index_lotto_prizes_on_code", unique: true
    t.index ["lotto_schema_id"], name: "index_lotto_prizes_on_lotto_schema_id"
  end

  create_table "lotto_schemas", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.decimal "price", precision: 15, scale: 8
    t.integer "range_from"
    t.integer "range_to"
    t.integer "win_number"
    t.boolean "duplicate"
    t.string "new_round_at"
    t.string "end_round_at"
    t.string "fee_type"
    t.decimal "fee_value", precision: 15, scale: 8
    t.decimal "initial_amount", precision: 15, scale: 8
    t.boolean "enable"
    t.bigint "currency_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "game_type"
    t.decimal "previous_game", precision: 15, scale: 8
    t.index ["currency_id"], name: "index_lotto_schemas_on_currency_id"
  end

  create_table "transactions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "trans_type"
    t.decimal "amount", precision: 15, scale: 8
    t.bigint "currency_id", null: false
    t.bigint "user_id", null: false
    t.bigint "account_id", null: false
    t.string "comment"
    t.string "error"
    t.datetime "ext_tran_date"
    t.string "ext_tran_id"
    t.string "status"
    t.decimal "before_balance", precision: 15, scale: 8
    t.decimal "after_balance", precision: 15, scale: 8
    t.string "game_session"
    t.string "source"
    t.integer "original_trans_id"
    t.decimal "original_amount", precision: 15, scale: 8
    t.bigint "original_currency_id"
    t.string "custom_info_01"
    t.string "custom_info_02"
    t.string "custom_info_03"
    t.string "custom_info_04"
    t.string "custom_info_05"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "doc_id"
    t.index ["account_id"], name: "index_transactions_on_account_id"
    t.index ["currency_id"], name: "index_transactions_on_currency_id"
    t.index ["doc_id"], name: "index_transactions_on_doc_id"
    t.index ["original_currency_id"], name: "index_transactions_on_original_currency_id"
    t.index ["user_id"], name: "index_transactions_on_user_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "accounts", "currencies"
  add_foreign_key "accounts", "users"
  add_foreign_key "configs", "config_sets"
  add_foreign_key "docs", "currencies"
  add_foreign_key "docs", "doc_types"
  add_foreign_key "docs", "users"
  add_foreign_key "lotto_inst", "lotto_schemas"
  add_foreign_key "lotto_prizes", "lotto_schemas"
  add_foreign_key "lotto_schemas", "currencies"
  add_foreign_key "transactions", "accounts"
  add_foreign_key "transactions", "currencies"
  add_foreign_key "transactions", "currencies", column: "original_currency_id"
  add_foreign_key "transactions", "users"
end
