class AppBuild 

  include Comparable

  attr_accessor :apps_dir, :app_name, :build_version

  def initialize(apps_dir, app_name, build_version)
    @apps_dir = apps_dir
    @app_name = app_name 
    @build_version = build_version
  end

  def build_file_root_path
    @apps_dir.join(app_name, build_version)
  end

  def release
    @build_version.split('.')[0...-1].join('.')
  end

  def supports_device?(device)
    device_families.include? device
  end

  def version_parts
    self.build_version.split('.').map do |version_part|
      if version_part.to_i.to_s == version_part
        version_part.to_i.to_s.rjust(10,'0')
      else
        version_part
      end
    end
  end

  def <=>(other)
    self.version_parts <=> other.version_parts
  end

  def ==(other)
    self.apps_dir==other.apps_dir && self.app_name==other.app_name && self.build_version==other.build_version
  end
end