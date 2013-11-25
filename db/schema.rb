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

ActiveRecord::Schema.define(version: 20131007170821) do

  create_table "books", force: true do |t|
    t.string   "name"
    t.string   "code"
    t.string   "author"
    t.string   "last_updated_at"
    t.integer  "source_id"
    t.string   "url"
    t.string   "source_ref_id"
    t.integer  "view_count",                   default: 0
    t.string   "desc"
    t.boolean  "recommend",                    default: false
    t.boolean  "hot",                          default: false
    t.integer  "word_count",                   default: 0
    t.integer  "comment_count",                default: 0
    t.integer  "chapters_count",               default: 0
    t.integer  "contents_count",               default: 0
    t.boolean  "content_active",               default: false
    t.datetime "deleted_at"
    t.boolean  "deleted",                      default: false
    t.integer  "last_chapter_id"
    t.string   "last_chapter_url"
    t.string   "chapter_status",    limit: 18, default: "Pending"
    t.string   "last_chapter_name"
    t.string   "chapter_url"
    t.string   "status",                       default: "Pending"
    t.string   "book_status"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "books", ["author"], name: "index_books_author", using: :btree
  add_index "books", ["category_id"], name: "index_books_on_category_id", using: :btree
  add_index "books", ["chapter_status"], name: "index_books_chapter_status", using: :btree
  add_index "books", ["last_chapter_id"], name: "index_books_on_last_chapter_id", using: :btree
  add_index "books", ["name"], name: "index_books_name", using: :btree
  add_index "books", ["source_id"], name: "index_books_on_source_id", using: :btree
  add_index "books", ["url"], name: "books_url", using: :btree

  create_table "categories", force: true do |t|
    t.string   "name"
    t.integer  "books_count"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "view_count"
  end

  add_index "categories", ["name"], name: "index_category_name", using: :btree

  create_table "chapter_ids", id: false, force: true do |t|
    t.integer  "id"
    t.string   "status",     default: "Pending"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "chapters", force: true do |t|
    t.integer  "book_id"
    t.string   "name"
    t.string   "url"
    t.datetime "deleted_at"
    t.string   "deleted"
    t.integer  "pre_id"
    t.integer  "next_id"
    t.integer  "volume_id"
    t.string   "code"
    t.integer  "view_count"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status",     limit: 18, default: "Pending"
  end

  add_index "chapters", ["book_id"], name: "index_chapters_on_book_id", using: :btree
  add_index "chapters", ["status"], name: "index_chapter_status", using: :btree
  add_index "chapters", ["url"], name: "index_chapter_url", using: :btree
  add_index "chapters", ["volume_id"], name: "index_chapters_on_volume_id", using: :btree

  create_table "click_logs", force: true do |t|
    t.integer  "user_id"
    t.integer  "ref_id"
    t.string   "ref_clazz"
    t.string   "ref_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "click_logs", ["user_id"], name: "index_click_logs_on_user_id", using: :btree

  create_table "contents", force: true do |t|
    t.integer  "book_id"
    t.integer  "chapter_id"
    t.integer  "volume_id"
    t.text     "content",    limit: 2147483647
    t.integer  "word_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contents", ["book_id"], name: "index_contents_on_book_id", using: :btree
  add_index "contents", ["chapter_id"], name: "index_contents_on_chapter_id", using: :btree
  add_index "contents", ["volume_id"], name: "index_contents_on_volume_id", using: :btree

  create_table "error_urls", force: true do |t|
    t.string   "url"
    t.string   "status"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "favourites", force: true do |t|
    t.integer  "user_id"
    t.integer  "book_id"
    t.datetime "deleted_at"
    t.boolean  "deleted",    default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "favourites", ["book_id"], name: "index_favourites_on_book_id", using: :btree
  add_index "favourites", ["user_id"], name: "index_favourites_on_user_id", using: :btree

  create_table "proxy_servers", force: true do |t|
    t.boolean  "active"
    t.string   "ip"
    t.string   "port"
    t.string   "status"
    t.integer  "count"
    t.integer  "succ_count"
    t.integer  "error_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "read_book_histories", force: true do |t|
    t.integer  "user_id"
    t.integer  "book_id"
    t.integer  "current_chapter_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status",             limit: 18, default: "Pending"
    t.integer  "view_count",                    default: 1
  end

  add_index "read_book_histories", ["book_id"], name: "index_read_book_histories_on_book_id", using: :btree
  add_index "read_book_histories", ["user_id"], name: "index_read_book_histories_on_user_id", using: :btree

  create_table "read_chapter_histories", force: true do |t|
    t.integer  "user_id"
    t.integer  "book_id"
    t.integer  "chapter_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "read_chapter_histories", ["book_id"], name: "index_read_chapter_histories_on_book_id", using: :btree
  add_index "read_chapter_histories", ["chapter_id"], name: "index_read_chapter_histories_on_chapter_id", using: :btree
  add_index "read_chapter_histories", ["user_id"], name: "index_read_chapter_histories_on_user_id", using: :btree

  create_table "search_logs", force: true do |t|
    t.integer  "user_id"
    t.integer  "search_word_id"
    t.string   "q"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "search_logs", ["search_word_id"], name: "index_search_logs_on_search_word_id", using: :btree
  add_index "search_logs", ["user_id"], name: "index_search_logs_on_user_id", using: :btree

  create_table "search_words", force: true do |t|
    t.string   "q"
    t.integer  "count",      default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "user_name"
    t.string   "mobile"
    t.integer  "sex"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

  create_table "volumes", force: true do |t|
    t.integer  "book_id"
    t.string   "name"
    t.integer  "parent_id"
    t.integer  "next_id"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "volumes", ["book_id"], name: "index_volumes_on_book_id", using: :btree

end
