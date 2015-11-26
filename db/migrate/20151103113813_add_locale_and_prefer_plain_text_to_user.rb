class AddLocaleAndPreferPlainTextToUser < ActiveRecord::Migration
  def change
    add_column :users, :locale, :string
    add_column :users, :prefer_plain_text, :boolean, default: false, null: false
  end
end
