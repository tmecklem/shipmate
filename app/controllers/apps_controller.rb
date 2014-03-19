require 'browser'

class AppsController < ApplicationController

  include AppListingModule

  attr_accessor :ios_dir
  attr_accessor :android_dir

  def initialize
    @ios_dir,@android_dir = app_dirs = [Shipmate::Application.config.ios_dir,Shipmate::Application.config.android_dir]
    app_dirs.each do |app_dir|
      FileUtils.mkdir_p(app_dir)
    end
    super
  end

  def index
    @ios_app_names = app_names(@ios_dir)
    @android_app_names = app_names(@android_dir)
  end

  def app_names(app_dir)
    app_type = app_dir == @ios_dir ? IOS_APP_TYPE : ANDROID_APP_TYPE
    subdirectories(app_dir).sort.select do |app_name|
      app_builds = self.app_builds(app_name,app_dir,app_type)

      if app_type == IOS_APP_TYPE   # Only iOS has different apps for phone and tablets
        (app_builds.first && app_builds.first.supports_device?(@device_type)) || @device_type == :desktop
      end

      app_builds
    end
  end

end
