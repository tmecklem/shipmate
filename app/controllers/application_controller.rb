class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :prepare_for_mobile_views

  before_action do
    @device_type = :iphone if browser.iphone? or browser.ipod?
    @device_type = :ipad if browser.ipad?
    @device_type = :android if browser.android?
    @device_type ||= :desktop
  end

  private

  def prepare_for_mobile_views
    if browser.iphone? or browser.ipod? or browser.ipad? or browser.android?
      request.format = :mobile
    end
  end

end
