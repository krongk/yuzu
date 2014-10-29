class CreateShops < ActiveRecord::Migration
  def change
    create_table :shops do |t|
      t.string :title
      t.references :user, index: true
      t.references :region, index: true
      t.references :city, index: true
      t.references :district, index: true
      t.string :detail_address
      t.text :content
      t.string :contact_name
      t.string :contact_phone
      t.string :website
      t.string :source
      t.string :source_url
      t.string :is_processed, default: 'n'

      t.timestamps
    end
  end
end
