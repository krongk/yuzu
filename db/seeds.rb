# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# Environment variables (ENV['...']) can be set in the file config/application.yml.
# See http://railsapps.github.io/rails-environment-variables.html
puts 'ROLES'
YAML.load(ENV['ROLES']).each do |role|
  Role.find_or_create_by_name(role)
  puts 'role: ' << role
end

puts 'DEFAULT USERS'
user = User.find_or_create_by_email :name => ENV['ADMIN_NAME'].dup, :email => ENV['ADMIN_EMAIL'].dup, :password => ENV['ADMIN_PASSWORD'].dup, :password_confirmation => ENV['ADMIN_PASSWORD'].dup
puts 'user: ' << user.name
#user.confirm!
user.add_role :admin

puts 'init templetes'
Admin::Keystore.put('templete', 'default')
Admin::Keystore.put('site_name', 'Rain CMS')

puts "create new channel"
Admin::Channel.create!(
  :parent_id    => nil,
  :typo         => 'article',
  :title        => '首页',
  :short_title  => 'index',
  :properties   => 1,
  :default_url  => nil,
  :tmp_index    => 'temp_index.html',
  :tmp_detail   => 'temp_index.html',
  :keywords     => '首页',
  :description  => ''
)

Region.create(:name => '北京')
    Region.create(:name => '天津')
    Region.create(:name => '河北')
    Region.create(:name => '山西')
    Region.create(:name => '内蒙古')
    Region.create(:name => '辽宁')
    Region.create(:name => '吉林')
    Region.create(:name => '黑龙江')
    Region.create(:name => '上海')
    Region.create(:name => '江苏')
    Region.create(:name => '浙江')
    Region.create(:name => '安徽')
    Region.create(:name => '福建')
    Region.create(:name => '江西')
    Region.create(:name => '山东')
    Region.create(:name => '河南')
    Region.create(:name => '湖北')
    Region.create(:name => '湖南')
    Region.create(:name => '广东')
    Region.create(:name => '广西')
    Region.create(:name => '海南')
    Region.create(:name => '重庆')
    Region.create(:name => '四川')
    Region.create(:name => '贵州')
    Region.create(:name => '云南')
    Region.create(:name => '西藏')
    Region.create(:name => '陕西')
    Region.create(:name => '甘肃')
    Region.create(:name => '青海')
    Region.create(:name => '宁夏')
    Region.create(:name => '新疆')