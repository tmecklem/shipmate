require 'plist'
require 'shipmate/ipa_parser'

class AppsController < ApplicationController

  attr_accessor :apps_dir

  def initialize
    @apps_dir = Rails.root.join('public','apps')
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
    ipa_file = @apps_dir.join(@app_name,build_version,"#{@app_name}-#{build_version}.ipa")
    ipa_parser = Shipmate::IpaParser.new(ipa_file)
    plist_hash = ipa_parser.extract_manifest(ipa_parser.parse_plist)
    plist_hash["items"][0]["assets"][0]['url'] = "#{request.base_url}/public/apps/#{@app_name}/#{build_version}/#{@app_name}-#{build_version}.ipa"
    
    respond_to do |format|
      format.plist { render :text => plist_hash.to_plist }
    end
  end

  def subdirectories(dir)
    Dir.entries(dir).select { |entry| File.directory?(File.join(dir, entry)) and not entry.eql?('.') and not entry.eql?('..') }
  end


end
