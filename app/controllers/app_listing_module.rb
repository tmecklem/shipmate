require 'ios_build'

module AppListingModule

  IOS_APP_TYPE = 1
  ANDROID_APP_TYPE = 2

  def app_builds(app_name,app_dir,app_type)
    app_builds = subdirectories(app_dir.join(app_name)).map do |build_version|
      if app_type == IOS_APP_TYPE
        IosBuild.new(app_dir, app_name, build_version)
      elsif app_type == ANDROID_APP_TYPE
        AppBuild.new(app_dir, app_name, build_version)
      end
        
    end
    app_builds.sort.reverse
  end

  def subdirectories(dir)
    Dir.entries(dir).select do |entry| 
      File.directory?(File.join(dir, entry)) and not entry.eql?('.') and not entry.eql?('..') 
    end
  end

end