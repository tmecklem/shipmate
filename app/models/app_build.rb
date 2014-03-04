require 'ipa'

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

  def ipa_file_path
    build_file_root_path.join("#{app_name}-#{build_version}.ipa")
  end

  def ipa_file?
    File.file? ipa_file_path
  end

  def icon_file_path
    path = build_file_root_path.join("Icon.png")
    if !File.file?(path)
     extract_icon_to_file(ipa_file_path, path)
    end
    if File.file?(path) then path else nil end
  end

  def icon_file?
    icon_file_path = self.icon_file_path
    !icon_file_path.nil? and File.file?(icon_file_path)
  end

  def ipa_checksum
      Digest::SHA1.hexdigest( File.read(ipa_file_path) )
  end

  def release
    @build_version.split('.')[0...-1].join('.')
  end

  def info_plist_hash
    ipa_info = nil
    begin
      IPA::IPAFile.open(ipa_file_path) do |ipa| 
        ipa_info = ipa.info
      end
    rescue Zip::ZipError => e
      puts e
    end
    ipa_info
  end

  def manifest_plist_hash
      info_plist_hash = self.info_plist_hash
      manifest = {}
      assets = [{'kind'=>'software-package', 'url'=>'__URL__'},{'kind'=>'display-image','needs-shine'=>false,'url'=>'__URL__'}]
      metadata = {}
      metadata["bundle-identifier"] = info_plist_hash["CFBundleIdentifier"]
      metadata["bundle-version"] = info_plist_hash["CFBundleVersion"]
      metadata["kind"] = "software"
      metadata["title"] = "#{info_plist_hash['CFBundleDisplayName']} #{info_plist_hash['CFBundleVersion']}"
      metadata["subtitle"] = "#{info_plist_hash['CFBundleDisplayName']} #{info_plist_hash['CFBundleVersion']}"

      items = [{"assets"=>assets, "metadata"=>metadata}]
      manifest["items"] = items

      manifest

  end

  def extract_icon_to_file(ipa_file, icon_file)
    icon_destination = Pathname.new(icon_file)
    begin
      IPA::IPAFile.open(ipa_file) do |ipa| 
        proc_that_returns_icon_data = ipa.icons["Icon.png"] || ipa.icons["Icon@2x.png"]
        File.open(icon_destination, 'wb') do
          |f| f.write proc_that_returns_icon_data.call()
        end
      end
    rescue Zip::ZipError

    end
  end

  def <=>(other)
    version_parts = self.build_version.split('.')
    other_version_parts = other.build_version.split('.')
    version_parts <=> other_version_parts
  end

  def ==(other)
    self.apps_dir==other.apps_dir && self.app_name==other.app_name && self.build_version==other.build_version
  end

end