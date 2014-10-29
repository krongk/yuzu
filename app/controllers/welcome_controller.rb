class WelcomeController < ApplicationController

  def index

  end

  def search
    @pages = Admin::Page.search(params[:search]).order("updated_at DESC").page(params[:page])
    @channel ||= Admin::Channel.first 

    #comment
    @comment = Comment.new
  end

  def tag
    @pages = Admin::Page.tagged_with(params[:tag]).order("updated_at DESC").page(params[:page])
    @channel ||= Admin::Channel.first

    #comment
    @comment = Comment.new
  end

end
