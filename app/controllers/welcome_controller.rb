class WelcomeController < ApplicationController

  def index

  end

  def search
    not_found if params[:search].blank?
    
    @posts = Admin::Page.search(params[:search]).order("updated_at DESC").page(params[:page])
    @jobs = Job.search(params[:search]).page(params[:page])
    @products = Product.search(params[:search]).page(params[:page])
  end

  def tag
    @pages = Admin::Page.tagged_with(params[:tag]).order("updated_at DESC").page(params[:page])
    @channel ||= Admin::Channel.first

    #comment
    @comment = Comment.new
  end

end
