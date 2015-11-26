class CreateLabels < ActiveRecord::Migration
  def change
    create_table :labels do |t|
      t.string :name
      t.string :color

      t.timestamps null: false
    end
  end
end
