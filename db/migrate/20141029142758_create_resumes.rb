class CreateResumes < ActiveRecord::Migration
  def change
    create_table :resumes do |t|
      t.references :user, index: true
      t.integer :cate_id, default: 0
      t.string :name
      t.text :summary
      t.string :sex
      t.string :age
      t.string :education
      t.string :work_year
      t.text :content
      t.string :qq
      t.references :region, index: true
      t.references :city, index: true
      t.references :district, index: true
      t.integer :pv_count, default: 0
      t.integer :fav_count, default: 0
      t.string :is_processed, default: 'n'

      t.timestamps
    end
  end
end
