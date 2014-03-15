require 'browser'

class AppsController < ApplicationController

  APP_ASSET_INDEX = 0
  ICON_ASSET_INDEX = 1

  attr_accessor :ios_dir

  def initialize
    @ios_dir = Shipmate::Application.config.ios_dir
    FileUtils.mkdir_p(@ios_dir)
    super
  end

  def index
    @app_names = subdirectories(@ios_dir).sort.select do |app_name|
      app_builds = self.app_builds(app_name)
      (app_builds.first && app_builds.first.supports_device?(@device_type)) || @device_type == :desktop
    end
  end

  #shared

  def app_builds(app_name)
    app_dir = @ios_dir.join(app_name)
    app_builds = subdirectories(app_dir).map do |build_version|
      AppBuild.new(@ios_dir, app_name, build_version)
    end
    app_builds.sort.reverse
  end

  def subdirectories(dir)
    Dir.entries(dir).select { |entry| File.directory?(File.join(dir, entry)) and not entry.eql?('.') and not entry.eql?('..') }
  end

end
