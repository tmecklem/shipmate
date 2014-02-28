require 'shipmate/ipa_parser'
require 'browser'

class AppsController < ApplicationController

  APP_ASSET_INDEX = 0
  ICON_ASSET_INDEX = 1

  attr_accessor :apps_dir

  before_action do
    @device_type = "iPhone" if browser.iphone? or browser.ipod?
    @device_type = "iPad" if browser.ipad? 
    @device_type ||= "Desktop"
  end

  def initialize
    @apps_dir = Shipmate::Application.config.apps_dir || Rails.root.join('public','apps')
    FileUtils.mkdir_p(@apps_dir)
    super
  end

  def index
    @app_names = subdirectories(@apps_dir).sort
  end

  def list_app_releases
    @app_name = params[:app_name]
    app_dir = @apps_dir.join(@app_name)
    app_builds = subdirectories(app_dir)
    
    app_builds.map! do |app_build|
      app_build.split('.')[0...-1].join('.')
    end
    app_builds.uniq!
    @app_releases = VersionSorter.rsort(app_builds)

  end

  def list_app_builds
    @app_name = params[:app_name]
    app_dir = @apps_dir.join(@app_name)
    app_builds = subdirectories(app_dir)

    app_builds.select! do |app_build|
      app_build.split('.')[0...-1].join('.').eql?(params[:app_release])
    end

    @release_builds = VersionSorter.rsort(app_builds)
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
    ipa_file = @apps_dir.join(@app_name,build_version,"#{@app_name}-#{build_version}.ipa")
    ipa_parser = Shipmate::IpaParser.new(ipa_file)
    plist_hash = ipa_parser.extract_manifest(ipa_parser.parse_plist)
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
