class AddTypeToUser < ActiveRecord::Migration
  def change
    add_column :users, :phone, :string
    add_column :users, :default_password, :string, default: '000000'
    add_column :users, :typo, :string, default: 'unknown'
    add_column :users, :is_processed, :string, default: 'n'
  end
end
