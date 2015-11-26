class CreateRules < ActiveRecord::Migration
  def change
    create_table :rules do |t|
      t.string :fiter_field
      t.integer :fiter_operation, default: 0, null: false
      t.string :fiter_value
      t.integer :action_operation, default: 0, null: false
      t.string :action_value

      t.timestamps null: false
    end
  end
end
