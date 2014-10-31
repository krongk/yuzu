class Shop < ActiveRecord::Base
  default_scope { order('updated_at DESC') } 

  belongs_to :user
  belongs_to :region
  belongs_to :city
  belongs_to :district
  attr_accessor :typo #user or shop

end
