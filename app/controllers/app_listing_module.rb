module AppListingModule

  def app_builds(app_name,app_dir)
    app_builds = subdirectories(app_dir.join(app_name)).map do |build_version|
      AppBuild.new(app_dir, app_name, build_version)
    end
    app_builds.sort.reverse
  end

  def subdirectories(dir)
    Dir.entries(dir).select do |entry| 
      File.directory?(File.join(dir, entry)) and not entry.eql?('.') and not entry.eql?('..') 
    end
  end

end