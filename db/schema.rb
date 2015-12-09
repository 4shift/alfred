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

ActiveRecord::Schema.define(version: 20151208134854) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string   "subdomain",  default: "", null: false
    t.integer  "owner_id",   default: 0,  null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "tel",        default: "", null: false
    t.string   "emp_count",  default: "", null: false
  end

  create_table "attachments", force: :cascade do |t|
    t.integer  "attachable_id"
    t.string   "attachable_type"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "attachments", ["attachable_type", "attachable_id"], name: "index_attachments_on_attachable_type_and_attachable_id", using: :btree

  create_table "conversations", force: :cascade do |t|
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "conversations", ["recipient_id"], name: "index_conversations_on_recipient_id", using: :btree
  add_index "conversations", ["sender_id"], name: "index_conversations_on_sender_id", using: :btree

  create_table "email_addresses", force: :cascade do |t|
    t.string   "email"
    t.boolean  "default",            default: false, null: false
    t.string   "verification_token"
    t.string   "name"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  create_table "labelings", force: :cascade do |t|
    t.integer  "label_id"
    t.integer  "labelable_id"
    t.string   "labelable_type"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "labelings", ["label_id", "labelable_id", "labelable_type"], name: "unique_labeling_label", unique: true, using: :btree
  add_index "labelings", ["label_id"], name: "index_labelings_on_label_id", using: :btree
  add_index "labelings", ["labelable_type", "labelable_id"], name: "index_labelings_on_labelable_type_and_labelable_id", using: :btree

  create_table "labels", force: :cascade do |t|
    t.string   "name"
    t.string   "color"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "messages", force: :cascade do |t|
    t.text     "body"
    t.integer  "conversation_id"
    t.integer  "user_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "messages", ["conversation_id"], name: "index_messages_on_conversation_id", using: :btree
  add_index "messages", ["user_id"], name: "index_messages_on_user_id", using: :btree

  create_table "notifications", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "notifiable_id"
    t.string   "notifiable_type"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "notifications", ["notifiable_type", "notifiable_id"], name: "index_notifications_on_notifiable_type_and_notifiable_id", using: :btree
  add_index "notifications", ["user_id"], name: "index_notifications_on_user_id", using: :btree

  create_table "replies", force: :cascade do |t|
    t.text     "content"
    t.integer  "ticket_id"
    t.integer  "user_id"
    t.string   "message_id"
    t.string   "content_type",             default: "html"
    t.boolean  "draft",                    default: false,  null: false
    t.string   "raw_message_file_name"
    t.string   "raw_message_content_type"
    t.integer  "raw_message_file_size"
    t.datetime "raw_message_updated_at"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

  add_index "replies", ["message_id"], name: "index_replies_on_message_id", using: :btree
  add_index "replies", ["ticket_id"], name: "index_replies_on_ticket_id", using: :btree
  add_index "replies", ["user_id"], name: "index_replies_on_user_id", using: :btree

  create_table "rules", force: :cascade do |t|
    t.string   "fiter_field"
    t.integer  "fiter_operation",  default: 0, null: false
    t.string   "fiter_value"
    t.integer  "action_operation", default: 0, null: false
    t.string   "action_value"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "status_changes", force: :cascade do |t|
    t.integer  "ticket_id"
    t.integer  "status",     default: 0, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "status_changes", ["ticket_id"], name: "index_status_changes_on_ticket_id", using: :btree

  create_table "tickets", force: :cascade do |t|
    t.string   "subject"
    t.text     "content"
    t.integer  "assignee_id"
    t.string   "message_id"
    t.integer  "user_id"
    t.string   "content_type",             default: "html"
    t.integer  "status",                   default: 0,         null: false
    t.integer  "priority",                 default: 0,         null: false
    t.integer  "to_email_address_id"
    t.integer  "locked_by_id"
    t.datetime "locked_at"
    t.string   "raw_message_file_name"
    t.string   "raw_message_content_type"
    t.integer  "raw_message_file_size"
    t.datetime "raw_message_updated_at"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.string   "username"
    t.string   "os",                       default: "Unknown", null: false
    t.string   "browser",                  default: "Unknown", null: false
    t.string   "browser_version",          default: "Unknown", null: false
    t.string   "ref_url",                  default: "",        null: false
    t.string   "ipaddress",                default: "",        null: false
  end

  add_index "tickets", ["assignee_id"], name: "index_tickets_on_assignee_id", using: :btree
  add_index "tickets", ["locked_by_id"], name: "index_tickets_on_locked_by_id", using: :btree
  add_index "tickets", ["message_id"], name: "index_tickets_on_message_id", using: :btree
  add_index "tickets", ["priority"], name: "index_tickets_on_priority", using: :btree
  add_index "tickets", ["status"], name: "index_tickets_on_status", using: :btree
  add_index "tickets", ["to_email_address_id"], name: "index_tickets_on_to_email_address_id", using: :btree
  add_index "tickets", ["user_id"], name: "index_tickets_on_user_id", using: :btree
  add_index "tickets", ["username"], name: "index_tickets_on_username", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "avatar"
    t.boolean  "admin",                  default: false, null: false
    t.boolean  "agent",                  default: false, null: false
    t.string   "signature"
    t.boolean  "notify",                 default: false, null: false
    t.string   "authentication_token"
    t.string   "time_zone"
    t.integer  "per_page",               default: 30,    null: false
    t.string   "locale"
    t.boolean  "prefer_plain_text",      default: false, null: false
    t.string   "provider"
    t.string   "uid"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "labelings", "labels"
  add_foreign_key "messages", "conversations"
  add_foreign_key "messages", "users"
  add_foreign_key "notifications", "users"
  add_foreign_key "replies", "tickets"
  add_foreign_key "replies", "users"
  add_foreign_key "status_changes", "tickets"
  add_foreign_key "tickets", "users"
end
