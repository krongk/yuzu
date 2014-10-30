class JobsController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update, :destroy]
  before_action :set_job, only: [:show, :edit, :update, :destroy]

  # GET /jobs
  # GET /jobs.json
  def index
    @jobs = if params[:cate_id]
      Job.where(cate_id: params[:cate_id]).page(params[:page])
    else
      Job.page(params[:page])
    end
    @jobs = current_user.jobs.page(params[:page]) if user_signed_in? && params[:user_id]

    @cate_name = ApplicationHelper::JOB_CATES[params[:cate_id].to_i]
    @cate_name ||= '招聘信息'
  end

  # GET /jobs/1
  # GET /jobs/1.json
  def show
  end

  # GET /jobs/new
  def new
    @job = Job.new
  end

  # GET /jobs/1/edit
  def edit
  end

  # POST /jobs
  # POST /jobs.json
  def create
    @user = current_user 
    @user ||= User.get(job_params[:mobile_phone], job_params[:email])
    not_found if @user.nil?

    @job = Job.new(job_params)
    @job.user_id = @user.id

    respond_to do |format|
      if @job.save
        if user_signed_in?
          format.html{ redirect_to user_root_path, notice: '信息发布成功.'}
        else
          format.html{ redirect_to new_user_session_path(id: @user.id), notice: '信息发布成功.' }
        end
      else
        format.html { render action: 'new' }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /jobs/1
  # PATCH/PUT /jobs/1.json
  def update
    respond_to do |format|
      if @job.update(job_params)
        format.html { redirect_to @job, notice: 'Job was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /jobs/1
  # DELETE /jobs/1.json
  def destroy
    @job.destroy
    respond_to do |format|
      format.html { redirect_to jobs_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_job
      @job = Job.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def job_params
      params.require(:job).permit(:user_id, :cate_id, :title, :mobile_phone, :email, :salary, :content, :region_id, :city_id, :district_id, :detail_address, :is_processed)
    end
end
