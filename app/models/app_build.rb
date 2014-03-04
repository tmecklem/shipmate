require 'ipa'
require 'CFPropertyList'

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

  def ipa_checksum
      Digest::SHA1.hexdigest( File.read(ipa_file_path) )
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

end