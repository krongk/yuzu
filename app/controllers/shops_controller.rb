
class ShopsController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update, :destroy]
  before_action :set_shop, only: [:show, :m, :edit, :update, :destroy]

  layout 'theme', only: [:m]
  
  # GET /shops
  # GET /shops.json
  def index
    @shops = if params[:user_id] || user_signed_in?
      Shop.where(user_id: params[:user_id] || current_user.id).page(params[:page])
    else
      Shop.all.page(params[:page])
    end
  end

  # GET /shops/1
  # GET /shops/1.json
  def show
    increase_pv(@shop)
  end

  #mobile view
  def m
    @user = @shop.user
  end

  # GET /shops/new
  def new
    @shop = Shop.new
  end

  # GET /shops/1/edit
  def edit
  end

  # POST /shops
  # POST /shops.json
  def create
    @user = current_user 
    @user ||= User.get(shop_params[:mobile_phone], shop_params[:email], shop_params[:typo])
    not_found if @user.nil?

    @shop = Shop.new(shop_params)
    @shop.user_id = @user.id

    if @shop.save
      if user_signed_in?
        redirect_to user_root_path, notice: '信息发布成功.'
      else
        redirect_to new_user_session_path(id: @user.id), notice: '信息发布成功.'
      end
    else
      respond_to do |format|
        format.html { render action: 'new' }
        format.json { render json: @shop.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /shops/1
  # PATCH/PUT /shops/1.json
  def update
     authorize!(@shop)
    respond_to do |format|
      if @shop.update(shop_params)
        format.html { redirect_to @shop, notice: '更新成功.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @shop.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shops/1
  # DELETE /shops/1.json
  def destroy
    authorize!(@shop)
    @shop.destroy
    respond_to do |format|
      format.html { redirect_to shops_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shop
      @shop = Shop.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def shop_params
      params.require(:shop).permit(:title, :typo, :user_id, :region_id, :city_id, :city_name, :district_id, :detail_address, :content, :contact_name, :mobile_phone, :email, :website, :source, :source_url, :is_processed)
    end
end
