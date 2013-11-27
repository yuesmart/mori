class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_filter :reset_session

  def twitter
    @user = User.find_for_twitter_oauth(request.env["omniauth.auth"], current_user)

    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication
      set_flash_message(:notice, :success, :kind => "Twitter") if is_navigational_format?
    else
      session["devise.twitter_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end  
  end
  
  def facebook
     @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)

     if @user.persisted?
       sign_in_and_redirect @user, :event => :authentication
       set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
     else
       session["devise.facebook_data"] = request.env["omniauth.auth"]
       redirect_to new_user_registration_url
     end
   end
   
	def google_oauth2    
	    @user = User.find_for_google_oauth2(request.env["omniauth.auth"], current_user)

	    if @user.persisted?
	      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google"
	      sign_in_and_redirect @user, :event => :authentication
	    else
	      session["devise.google_data"] = request.env["omniauth.auth"]
	      redirect_to new_user_registration_url
	    end
	end
  
  def github
    @user = User.find_for_github_oauth(env["omniauth.auth"], current_user)
    
    if @user.persisted?
      flash[:notice] = I18n.t(
        "devise.omniauth_callbacks.success", :kind => "GitHub" )
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise.github_data"] = env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
  
  private
  def reset_session
    session["devise.twitter_data"]  = nil
    session["devise.github_data"] = nil
    session["devise.google_data"] = nil
    session["devise.facebook_data"] = nil
  end
end