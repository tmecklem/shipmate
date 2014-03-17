require 'ipa'
require 'app_build'

class IosBuild < AppBuild

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

  def device_families
    families = info_plist_hash["UIDeviceFamily"].map do |family_id|
      if family_id == 1 
        :iphone
      elsif family_id == 2
        :ipad
      else
        family_id
      end
    end

    families << :ipad unless families.include?(:ipad)
    families
  end

end