class Product < ActiveRecord::Base
  default_scope { order('updated_at DESC') } 

  belongs_to :user
  belongs_to :region
  belongs_to :city
  belongs_to :district

  #only use to find or create user, not need to store in product table
  attr_accessor :mobile_phone, :email

  validates :cate_id, :title, presence: true

  #搜索
  def self.search(search)
    if search
      where('title LIKE ?', "%#{search}%")
    else
      []
    end
  end
  
end
