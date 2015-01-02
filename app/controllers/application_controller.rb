class ApplicationController < ActionController::Base
  include ApplicationHelper
  #to allow user login with email OR mobile_phone
  before_action :configure_permitted_parameters, if: :devise_controller?
  #add page cache
  include ActionController::Caching::Pages
  self.page_cache_directory = "#{Rails.root.to_s}/public/page_cache"

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :load_templete

  #catch exception
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => '没有权限访问，请联系管理员！'
  end
  rescue_from ActionController::RoutingError do |exception|
    not_found#  redirect_to root_path
  end

  #obj = site/site_page
  #call: authorize!(@site)
  def authorize!(obj)
    return if current_user.id == 1
    begin
      if obj.user_id != current_user.id
        raise CanCan::AccessDenied.new('没有权限！' )
      end
    rescue 
      raise CanCan::AccessDenied.new('没有权限！' )
    end
  end

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:mobile_phone, :email, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :mobile_phone, :email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:mobile_phone, :email, :password, :password_confirmation, :current_password) }
  end

  private
  #detect if a mobile device
  def mobile_device?
    !!(request.user_agent =~ /Mobile|webOS/i)
  end
  helper_method :mobile_device?

  #this method initlize global variables.
  def load_templete
    @templete = Admin::Keystore.value_for('templete')
    @templete ||= 'default'
    @base_dir = "#{Rails.root}/public/templetes/#{@templete}/"
    Dir.chdir(@base_dir)
    @temp_list = Dir.glob("*.html").sort

    tempfiles = File.join(Rails.root, "public", "ckeditor_assets", "**", "*.{jpg, png, gif, jpeg}")
    @image_list = Dir.glob([tempfiles]).map{|i| i.sub(/^.*\/public/, '') }.sort
    @image_list = @image_list.select{|i| i =~ /thumb_/i}
  end

  #render 404 error
  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

end
