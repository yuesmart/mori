class ApplicationController < ActionController::Base
  before_filter :authenticate_user!
  
  protect_from_forgery with: :exception
  before_filter :init_params

  def init_params
    @page = params[:page]||1
    @q = params[:q]
    params[:user_id] = current_user.try(:id) if current_user
  end
end
