class Shop < ActiveRecord::Base
  default_scope { order('updated_at DESC') } 

  belongs_to :user
  belongs_to :region
  belongs_to :city
  belongs_to :district
  attr_accessor :typo #user or shop
  before_save :check_data

  #搜索
  def self.search(search)
    if search
      where('title LIKE ?', "%#{search}%")
    else
      []
    end
  end

  def self.recent(count = 10)
    order("updated_at DESC").limit(count)
  end

  private
    def check_data
      if self.city_id.nil?
        self.city_id = City.find_by(name: self.city_name).try(:id)
      end
    end
    
end
