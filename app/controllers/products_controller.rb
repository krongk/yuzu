class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  # GET /products
  # GET /products.json
  def index
    @products = Product.all
  end

  # GET /products/1
  # GET /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.json
  def create
    @user = current_user 
    @user ||= User.get(product_params[:mobile_phone], product_params[:email])
    not_found if @user.nil?

    @product = Product.new(product_params)
    @product.user_id = @user.id
    
    respond_to do |format|
      if @product.save
        if user_signed_in?
          format.html{ redirect_to user_root_path, notice: '信息发布成功.'}
        else
          format.html{ redirect_to new_user_session_path(id: @user.id), notice: '信息发布成功.' }
        end
      else
        format.html { render action: 'new' }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:user_id, :cate_id, :title, :mobile_phone, :email, :content, :price, :region_id, :city_id, :district_id, :detail_address, :is_processed)
    end
end
