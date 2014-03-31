require 'shipmate/ipa_parser'

class IosAppsController < AppsController

  include AppListingModule

  APP_ASSET_INDEX = 0
  ICON_ASSET_INDEX = 1

  attr_accessor :ios_dir

  def initialize
    @ios_dir = Shipmate::Application.config.ios_dir
    FileUtils.mkdir_p(@ios_dir)
    super
  end

  def list_app_releases
    @app_name = params[:app_name]
    app_builds = self.app_builds(@app_name, @ios_dir, IOS_APP_TYPE)

    @most_recent_build_hash = most_recent_build_by_release(app_builds)
    @app_releases = @most_recent_build_hash.keys.sort{|x,y| y.to_version_string<=>x.to_version_string }
    @mobileprovision = mobileprovision_file_url(@app_name)
  end

  def mobileprovision_file_url(app_name)
    mobileprovision_file = Dir.glob(@ios_dir.join(app_name,"*.mobileprovision")).first
    if mobileprovision_file
      "#{request.base_url}/apps/ios/#{app_name}/#{mobileprovision_file.split('/').last}"
    else
      nil
    end
  end

  def list_app_builds
    @app_name = params[:app_name]
    @app_release = params[:app_release]

    @app_builds = self.app_builds(@app_name, @ios_dir, IOS_APP_TYPE).select do |app_build|
      app_build.release.eql?(@app_release)
    end
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
    @app_build = IosBuild.new(@ios_dir, params[:app_name], params[:build_version])
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
    app_build = IosBuild.new(@ios_dir, app_name, build_version)
    plist_hash = app_build.manifest_plist_hash
    replace_url_in_plist_hash APP_ASSET_INDEX, "#{public_url_for_build_directory(@app_name, build_version)}/#{@app_name}-#{build_version}.ipa", plist_hash
    replace_url_in_plist_hash ICON_ASSET_INDEX, "#{public_url_for_build_directory(@app_name, build_version)}/Icon.png", plist_hash
    plist_hash
  end

  def public_url_for_build_directory(app_name, build_version)
    "#{request.base_url}/apps/ios/#{app_name}/#{build_version}"
  end

  def replace_url_in_plist_hash(asset_type, url, plist_hash)
    plist_hash["items"][0]["assets"][asset_type]['url'] = URI.escape(url)
  end

end
