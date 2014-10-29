class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.references :user, index: true
      t.integer :cate_id, default: 0
      t.string :title
      t.string :mobile_phone
      t.string :email
      t.string :salary
      t.text :content
      t.references :region, index: true
      t.references :city, index: true
      t.references :district, index: true
      t.string :detail_address
      t.string :is_processed, default: 'n'

      t.timestamps
    end
  end
end
