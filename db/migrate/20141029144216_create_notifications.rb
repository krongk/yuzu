class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string :message
      t.string :is_processed, default: 'n'

      t.timestamps
    end
  end
end
