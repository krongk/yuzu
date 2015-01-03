class User < ActiveRecord::Base
  rolify
  has_one :shop
  has_many :resumes
  has_many :products
  has_many :jobs
  has_many :pictures
  
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

  def is_active?
    return true if self.is_processed == 'y' || self.shop.is_processed == 'y'
    return false
  end

  #get this use has which product_cates, see ApplicationHelper::PRODUCT_CATES
  # [0, 1, 3]
  def active_cate_ids
    self.products.group_by(&:cate_id).keys.sort
  end

  def recent_jobs(count = 10)
    self.jobs.order("updated_at DESC").limit(count)
  end

  def recent_products(count = 10)
    self.products.order("updated_at DESC").limit(count)
  end

  # validates :mobile_phone,
  # :uniqueness => {
  #   :case_sensitive => false
  # }, :format => {with: /\A1(3|5|6|7|8|9)[0-9]{9}\z/, message: "请输入正确的手机号码"}
  ####################===to allow login with email OR mobile_phone end==========================================
  
  #{"email"=>"s@", "cate_id"=>"足疗师", "name"=>"sdsd", "summary"=>"awaww", "sex"=>"false", "age"=>"22", "education"=>"中专/技校", "work_year"=>"1-2年", "content"=>"awe", 
  # "mobile_phone"=>"18088887889", "qq"=>"3423", "region_id"=>"16", "city_id"=>"17", "district_id"=>"17"}
  def self.get(mobile_phone, email, typo = 'shop')
    return if mobile_phone.blank? && email.blank?
    user = self.find_by(mobile_phone: mobile_phone)
    user ||= self.find_by(email: email)
    if user.nil?
      pwd = 'zy' + SecureRandom.hex(2).to_s
      user = self.create!(
        email: email, 
        mobile_phone: mobile_phone, 
        default_password: pwd, 
        password: pwd, 
        password_confirmation: pwd,
        typo: typo
      )
      SmsSendWorker.perform_async(mobile_phone, "【足浴114】尊敬的客户，您的账号初始密码为：#{pwd}, 请使用本手机号登录后台修改: http://zuyu114.com")
    end
    user
  end

  def self.get_tmp_user(name: 'tmp')
    begin
      email = "#{SecureRandom.hex(2)}@zuyu114.com"
    end while User.exists?(:email => email )

    user = User.create!(
      :name => name, 
      :email => email,
      :mobile_phone => '18000000000',
      :password => 'zuyu114', 
      :password_confirmation => 'zuyu114')
  end

end
