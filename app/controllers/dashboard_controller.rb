class DashboardController < ApplicationController
  before_action :authenticate_user!, except: [:post]

  def index
  end

  def post
    
  end
end
