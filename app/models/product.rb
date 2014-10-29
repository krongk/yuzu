class Product < ActiveRecord::Base
  belongs_to :user
  belongs_to :region
  belongs_to :city
  belongs_to :district
end
