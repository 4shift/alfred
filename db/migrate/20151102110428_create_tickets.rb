class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.string :subject
      t.text :content
      t.integer :assignee_id
      t.string :message_id
      t.references :user, index: true, foreign_key: true
      t.string :content_type,   default: "html"
      t.integer :status,        default: 0, null: false
      t.integer :priority,      default: 0, null: false
      t.integer :to_email_address_id
      t.integer :locked_by_id
      t.datetime :locked_at
      t.attachment :raw_message

      t.timestamps null: false
    end
    add_index :tickets, :assignee_id
    add_index :tickets, :message_id
    add_index :tickets, :status
    add_index :tickets, :priority
    add_index :tickets, :to_email_address_id
    add_index :tickets, :locked_by_id
  end
end
