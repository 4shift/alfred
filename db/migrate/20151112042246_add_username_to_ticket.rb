class AddUsernameToTicket < ActiveRecord::Migration
  def change
    add_column :tickets, :username, :string
    add_index :tickets, :username
  end
end
