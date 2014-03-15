class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action do
    @device_type = :iphone if browser.iphone? or browser.ipod?
    @device_type = :ipad if browser.ipad? 
    @device_type ||= :desktop
  end

end
