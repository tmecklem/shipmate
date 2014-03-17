require 'browser'

class AppsController < ApplicationController

  include AppListingModule

  attr_accessor :ios_dir
  attr_accessor :android_dir

  def initialize
    @ios_dir = Shipmate::Application.config.ios_dir
    FileUtils.mkdir_p(@ios_dir)
    @android_dir = Shipmate::Application.config.android_dir
    FileUtils.mkdir_p(@android_dir)
    super
  end

  def index
    @ios_app_names = ios_app_names
    @android_app_names = android_app_names
  end

  def ios_app_names 
    subdirectories(@ios_dir).sort.select do |app_name|
      app_builds = self.app_builds(app_name,@ios_dir)
      (app_builds.first && app_builds.first.supports_device?(@device_type)) || @device_type == :desktop
    end
  end

  def android_app_names
    subdirectories(@android_dir).sort.select do |app_name|
      app_builds = self.app_builds(app_name,@android_dir)
      (app_builds.first && app_builds.first.supports_device?(@device_type)) || @device_type == :desktop
    end
  end 

end
