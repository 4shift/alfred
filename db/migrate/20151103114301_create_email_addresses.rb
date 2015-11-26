class CreateEmailAddresses < ActiveRecord::Migration
  def change
    create_table :email_addresses do |t|
      t.string :email
      t.boolean :default, default: false, null: false
      t.string :verification_token
      t.string :name

      t.timestamps null: false
    end
  end
end
