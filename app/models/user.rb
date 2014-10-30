class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable, :registerable, 
  
  # devise :database_authenticatable, 
  #        :recoverable, :rememberable, :trackable, :validatable

  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :registerable 

  ####################===to allow login with email OR mobile_phone start==========================================
  # Virtual attribute for authenticating by either username or email
  # This is in addition to a real persisted field like 'username'
  attr_accessor :login

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["mobile_phone = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end

  validates :mobile_phone,
  :uniqueness => {
    :case_sensitive => false
  }, :format => {with: /\A1(3|5|6|7|8|9)[0-9]{9}\z/, message: "请输入正确的手机号码"}
  ####################===to allow login with email OR mobile_phone end==========================================
  
  #{"email"=>"s@", "cate_id"=>"足疗师", "name"=>"sdsd", "summary"=>"awaww", "sex"=>"false", "age"=>"22", "education"=>"中专/技校", "work_year"=>"1-2年", "content"=>"awe", 
  # "mobile_phone"=>"18088887889", "qq"=>"3423", "region_id"=>"16", "city_id"=>"17", "district_id"=>"17"}
  def self.get(mobile_phone, email)
    return if mobile_phone.blank? && email.blank?
    user = self.find_by(mobile_phone: mobile_phone)
    user ||= self.find_by(email: email)
    user ||= self.create!(email: email, mobile_phone: mobile_phone, default_password:ENV['DEFAULT_PASSWORD'], password: ENV['DEFAULT_PASSWORD'].dup, password_confirmation: ENV['DEFAULT_PASSWORD'].dup)
    user
  end

end
