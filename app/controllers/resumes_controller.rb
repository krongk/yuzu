class ResumesController < ApplicationController
  before_action :set_resume, only: [:show, :edit, :update, :destroy, :preview]

  # GET /resumes
  # GET /resumes.json
  def index
    @resumes = Resume.all
  end

  # GET /resumes/1
  # GET /resumes/1.json
  def show
  end

  # GET /resumes/new
  def new
    @resume = Resume.new
  end

  # GET /resumes/1/edit
  def edit
  end

  # POST /resumes
  # POST /resumes.json
  def create
    @user = current_user 
    @user ||= User.get(resume_params[:mobile_phone], resume_params[:email])
    not_found if @user.nil?

    @resume = Resume.new(resume_params)
    @resume.user_id = @user.id

    if @resume.save
        if user_signed_in?
          redirect_to user_root_path, notice: '信息发布成功.'
        else
          redirect_to new_user_session_path(id: @user.id), notice: '信息发布成功.'
        end
      else
        format.html { render action: 'new' }
        format.json { render json: @resume.errors, status: :unprocessable_entity }
      end
  end

  def preview

  end

  # PATCH/PUT /resumes/1
  # PATCH/PUT /resumes/1.json
  def update
    respond_to do |format|
      if @resume.update(resume_params)
        format.html { redirect_to @resume, notice: 'Resume was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @resume.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /resumes/1
  # DELETE /resumes/1.json
  def destroy
    @resume.destroy
    respond_to do |format|
      format.html { redirect_to resumes_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_resume
      @resume = Resume.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def resume_params
      params.require(:resume).permit(:email, :cate_id, :name, :summary, :sex, :age, :education, :work_year, :content, :mobile_phone, :qq, :region_id, :city_id, :district_id, :pv_count, :fav_count, :is_processed)
    end
end