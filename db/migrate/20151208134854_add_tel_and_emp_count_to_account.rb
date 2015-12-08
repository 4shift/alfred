class AddTelAndEmpCountToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :tel, :string
    add_column :accounts, :emp_count, :string
  end
end
