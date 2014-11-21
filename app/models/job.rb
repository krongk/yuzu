class Job < ActiveRecord::Base
  default_scope { order('updated_at DESC') } 

  belongs_to :user
  belongs_to :region
  belongs_to :city
  belongs_to :district

  #only use to find or create user, not need to store in job table
  attr_accessor :mobile_phone, :email
  #empty
  validates :title, :cate_id,  presence: true

  #搜索
  def self.search(search)
    if search
      where('title LIKE ?', "%#{search}%")
    else
      []
    end
  end

  def self.recent(count = 10)
    Job.order("updated_at DESC").limit(count)
  end
end
