class Resume < ActiveRecord::Base
  belongs_to :user
  belongs_to :region
  belongs_to :city
  belongs_to :district

  #empty
  validates :mobile_phone, :cate_id, :name, presence: true
  #length
  validates :mobile_phone, length: { is: 11 }
  #format
  validates :mobile_phone, format: { with: /\A1(3|5|6|7|8|9)[0-9]{9}\z/, message: "请输入正确的手机号码" }

end