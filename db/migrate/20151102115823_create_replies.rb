class CreateReplies < ActiveRecord::Migration
  def change
    create_table :replies do |t|
      t.text :content
      t.references :ticket, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.string :message_id
      t.string :content_type,       default: "html"
      t.boolean :draft,             default: false, null: false
      t.attachment :raw_message

      t.timestamps null: false
    end
    add_index :replies, :message_id
  end
end
