class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.references :user, index: true, foreign_key: true
      t.references :notifiable, polymorphic: true, index: true

      t.timestamps null: false
    end
  end
end
