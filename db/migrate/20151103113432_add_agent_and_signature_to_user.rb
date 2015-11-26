class AddAgentAndSignatureToUser < ActiveRecord::Migration
  def change
    add_column :users, :agent, :boolean, default: false, null: false
    add_column :users, :signature, :string
  end
end
