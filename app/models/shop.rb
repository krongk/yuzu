class Shop < ActiveRecord::Base
  default_scope { order('updated_at DESC') } 

  belongs_to :user
  belongs_to :region
  belongs_to :city
  belongs_to :district
  attr_accessor :typo #user or shop

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

end
