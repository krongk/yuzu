class Product < ActiveRecord::Base
  default_scope { order('updated_at DESC') } 

  belongs_to :user
  belongs_to :region
  belongs_to :city
  belongs_to :district

  #only use to find or create user, not need to store in product table
  attr_accessor :mobile_phone, :email

  validates :cate_id, :title, presence: true

  before_save :check_data

  #搜索
  def self.search(search)
    if search
      where('title LIKE ?', "%#{search}%")
    else
      []
    end
  end
  
  private
    def check_data
      if self.city_id.nil?
        self.city_id = City.find_by(name: self.city_name).try(:id)
      end
    end
  
end
