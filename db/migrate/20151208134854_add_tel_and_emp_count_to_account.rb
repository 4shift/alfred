class AddTelAndEmpCountToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :tel, :string, default: "", null: false
    add_column :accounts, :emp_count, :string, default: "", null: false
  end
end
