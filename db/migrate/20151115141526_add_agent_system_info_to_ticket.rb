class AddAgentSystemInfoToTicket < ActiveRecord::Migration
  def change
    add_column :tickets, :os, :string, default: 'Unknown', null: false
    add_column :tickets, :browser, :string, default: 'Unknown', null: false
    add_column :tickets, :browser_version, :string, default: 'Unknown', null: false
    add_column :tickets, :ref_url, :string, default: '', null: false
    add_column :tickets, :ipaddress, :string, default: '', null: false
  end
end
