class CreateForagerWubaRunKeys < ActiveRecord::Migration
  def change
    create_table :forager_wuba_run_keys do |t|
      t.string :typo, default: 'job'
      t.string :title
      t.string :short_title
      t.string :is_processed, default: 'n'

      t.timestamps
    end
  end
end
