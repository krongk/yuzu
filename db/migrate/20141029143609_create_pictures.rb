class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.references :user, index: true
      t.string :title
      t.string :source_type
      t.string :source_id
      t.attachment :asset
      t.timestamps
    end
  end
end
