class User < ActiveRecord::Base
  include SocialMediaAuthentication
  attr_accessor :login

  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable,
         :omniauth_providers => [:google_oauth2]

         def self.find_for_database_authentication(conditions)
     email_name_regex  = '[\w\.%\+\-]+'.freeze
     domain_head_regex = '(?:[A-Z0-9\-]+\.)+'.freeze
     domain_tld_regex  = '(?:[A-Z]{2}|com|org|net|edu|gov|mil|biz|info|mobi|name|aero|jobs|museum)'.freeze
     email_regex       = /\A#{email_name_regex}@#{domain_head_regex}#{domain_tld_regex}\z/i

    logger.debug "find_for_database_authentication:#{conditions.inspect}"

    login = conditions.delete(:login)
    login = conditions.delete(:name) if login.blank?

    if login =~ /^\d+$/ && login.length != 11
       u = where(conditions).where(["code = :login", {:login => login}]).first
       where(conditions).where(["name  = :login", {:login => login}]).first if u.nil?
    elsif  login =~ /^\d+$/ && login.length == 11
      where(conditions).where(["mobile = :login", {:login => login}]).first
    elsif login =~ email_regex 
      where(conditions).where(["email = :login", {:login => login}]).first
    else
      where(conditions).where(["name  = :login", {:login => login}]).first
    end
  end
end
