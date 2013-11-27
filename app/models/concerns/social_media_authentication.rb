module SocialMediaAuthentication
  extend ActiveSupport::Concern

  module ClassMethods

    def find_for_google_oauth2(access_token, signed_in_resource=nil)
        data = access_token.info
        user = User.where(email: data["email"]).first
        user = User.create(name: data["name"],email: data["email"],password: Devise.friendly_token[0,20]) if user.nil?
        user
    end

    def find_for_facebook_oauth(auth, signed_in_resource=nil)
      user = User.where(:provider => auth.provider, :uid => auth.uid).first
      user = User.create(name:auth.extra.raw_info.name,provider:auth.provider,uid:auth.uid,email:auth.raw_info.email, password:Devise.friendly_token[0,20]) if user.nil?
      user
    end

    def find_for_twitter_oauth(auth, signed_in_resource=nil)
      user = User.where(:provider => auth.provider, :uid => auth.uid).first
      user = User.create(name:auth.extra.raw_info.name,provider:auth.provider,uid:auth.uid,email:auth.raw_info.email, password:Devise.friendly_token[0,20]) if user.nil?
      user
    end

    def find_for_github_oauth(auth, signed_in_resource=nil)
      find_for_oauth auth, signed_in_resource
    end
    
    def find_for_oauth(auth, signed_in_resource=nil)
      raw_info =  auth["extra"]["raw_info"]
      user = User.where(:provider => auth.provider, :uid => auth.uid).first
      user = User.create!(name:raw_info["name"],provider:auth.provider,uid:auth.uid,email:raw_info["email"], password:Devise.friendly_token[0,20]) if user.nil?
      user
    end

    def new_with_session(params, session)
      super.tap do |user|
        if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
          user.email = data["email"] if user.email.blank?
        end
      end
    end
  end  
end