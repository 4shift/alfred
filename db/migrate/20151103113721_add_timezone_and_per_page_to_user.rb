class AddTimezoneAndPerPageToUser < ActiveRecord::Migration
  def change
    add_column :users, :time_zone, :string
    add_column :users, :per_page, :integer, default: 30, null: false
  end
end
