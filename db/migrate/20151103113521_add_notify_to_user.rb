class AddNotifyToUser < ActiveRecord::Migration
  def change
    add_column :users, :notify, :boolean, default: false, null: false
  end
end
