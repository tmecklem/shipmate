class AppBuild 

  attr_accessor :apps_dir, :app_name, :build_version

  def initialize(apps_dir, app_name, build_version)
    @apps_dir = apps_dir
    @app_name = app_name 
    @build_version = build_version
  end

  def build_file_root_path
    return @apps_dir.join(app_name, build_version)
  end

  def ipa_file_path
    return build_file_root_path.join("#{app_name}-#{build_version}.ipa")
  end

  def ipa_file?
    return File.file?(ipa_file_path)
  end

end