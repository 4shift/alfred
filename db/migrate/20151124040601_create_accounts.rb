class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :subdomain, default: "", null: false
      t.integer :owner_id, default: 0, null: false

      t.timestamps null: false
    end
  end
end
