require 'shipmate/apk_parser'

class AndroidAppsController < AppsController

  def list_app_builds
    @app_name = params[:app_name]
    @app_release = params[:app_release]
    @base_build_directory = public_url_for_build_directory

    @app_builds = self.app_builds(@app_name, @android_dir, ANDROID_APP_TYPE).select do |app_build|
      app_build.release.eql?(@app_release)
    end

  end

  def list_app_releases
    @app_name = params[:app_name]
    app_builds = self.app_builds(@app_name, @android_dir, ANDROID_APP_TYPE)

    @most_recent_build_hash = most_recent_build_by_release(app_builds)
    @base_build_directory = public_url_for_build_directory
    @app_releases = @most_recent_build_hash.keys.sort{|x,y| y.to_version_string<=>x.to_version_string }
  end

  def public_url_for_build_directory
    "#{request.base_url}/apps/android"
  end

  def most_recent_build_by_release(app_builds)
    most_recent_builds_hash = {}
    app_builds.each do |app_build|
      most_recent_builds_hash[app_build.release] ||= app_build
    end
    most_recent_builds_hash
  end
end
