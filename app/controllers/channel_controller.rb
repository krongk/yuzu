class ChannelController < ApplicationController
  def index
    @channel = Admin::Channel.find_by(short_title: params[:id])
    @channel ||= Admin::Channel.find_by(id: params[:id])
    not_found if @channel.nil?
    @posts = @channel.pages.order("updated_at DESC").page(params[:page])
  end

  def show
    @post = Admin::Page.find_by(id: params[:id])
    @channel = @post.channel
    not_found if @post.nil?
  end
end
