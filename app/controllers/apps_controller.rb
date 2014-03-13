require 'shipmate/ipa_parser'
require 'browser'

class AppsController < ApplicationController

  APP_ASSET_INDEX = 0
  ICON_ASSET_INDEX = 1

  attr_accessor :ios_dir

  before_action do
    @device_type = :iphone if browser.iphone? or browser.ipod?
    @device_type = :ipad if browser.ipad? 
    @device_type ||= :desktop
  end

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

  def list_app_releases
    @app_name = params[:app_name]
    app_builds = self.app_builds(@app_name)

    @most_recent_build_hash = most_recent_build_by_release(app_builds)
    @app_releases = VersionSorter.rsort(@most_recent_build_hash.keys)
    @mobileprovision = mobileprovision_file_url(@app_name)
  end

  def mobileprovision_file_url(app_name)
    mobileprovision_file = Dir.glob(@ios_dir.join(app_name,"*.mobileprovision")).first
    if mobileprovision_file
      "#{request.base_url}/apps/#{app_name}/#{mobileprovision_file.split('/').last}"
    else
      nil
    end
  end

  def list_app_builds
    @app_name = params[:app_name]
    @app_release = params[:app_release]

    @app_builds = self.app_builds(@app_name).select do |app_build|
      app_build.release.eql?(@app_release)
    end
  end

  def app_builds(app_name)
    app_dir = @ios_dir.join(app_name)
    app_builds = subdirectories(app_dir).map do |build_version|
      AppBuild.new(@ios_dir, app_name, build_version)
    end
    app_builds.sort.reverse
  end

  def most_recent_build_by_release(app_builds)
    most_recent_builds_hash = {}
    app_builds.each do |app_build|
      most_recent_builds_hash[app_build.release] ||= app_build
    end
    most_recent_builds_hash
  end

  def show_build
    expires_now
    @app_build = AppBuild.new(@ios_dir, params[:app_name], params[:build_version])
  end

  def show_build_manifest
    expires_now
    @app_name = params[:app_name]
    build_version = params[:build_version]
    
    respond_to do |format|
      format.plist { render :text => gen_plist_hash(@app_name, build_version).to_plist(plist_format: CFPropertyList::List::FORMAT_XML) }
    end
  end

  def gen_plist_hash(app_name, build_version)
    app_build = AppBuild.new(@ios_dir, app_name, build_version)
    plist_hash = app_build.manifest_plist_hash
    replace_url_in_plist_hash APP_ASSET_INDEX, "#{public_url_for_build_directory(@app_name, build_version)}/#{@app_name}-#{build_version}.ipa", plist_hash
    replace_url_in_plist_hash ICON_ASSET_INDEX, "#{public_url_for_build_directory(@app_name, build_version)}/Icon.png", plist_hash
    plist_hash
  end

  def public_url_for_build_directory(app_name, build_version)
    "#{request.base_url}/apps/#{app_name}/#{build_version}"
  end

  def replace_url_in_plist_hash(asset_type, url, plist_hash)
    plist_hash["items"][0]["assets"][asset_type]['url'] = URI.escape(url)
  end

  def subdirectories(dir)
    Dir.entries(dir).select { |entry| File.directory?(File.join(dir, entry)) and not entry.eql?('.') and not entry.eql?('..') }
  end


end
