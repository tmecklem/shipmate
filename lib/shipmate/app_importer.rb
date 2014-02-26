require 'yaml'
require 'ipa'
require 'pathname'
require 'digest'
require 'plist'

module Shipmate

  class AppImporter

    attr_reader :import_dir, :apps_dir

    def initialize(import_dir, apps_dir)
      @import_dir = Pathname.new(import_dir)
      @apps_dir = Pathname.new(apps_dir)

      FileUtils.mkdir_p(@import_dir)
      FileUtils.mkdir_p(@apps_dir)
    end

    def import_apps
      ipa_files = Dir.glob("#{@import_dir}/**/*").reject { |entry| !entry.upcase.end_with?('IPA') }
      ipa_files.each do |ipa_file|
        begin
          import_app ipa_file
        rescue
          puts "Unable to import #{ipa_file}"
        end
      end
    end

    def import_app(ipa_file)
      plist_hash = parse_ipa_plist(ipa_file)
      app_name = plist_hash["CFBundleDisplayName"]
      app_version = plist_hash["CFBundleVersion"]
      create_app_directory(app_name, app_version)
      touch_digest_file(calculate_digest(ipa_file), app_name, app_version)
      extract_icon_to_file(ipa_file, app_name, app_version)
      move_ipa_file(ipa_file, app_name, app_version)
      write_manifest_to_file(extract_manifest(plist_hash), app_name, app_version)
    end

    def parse_ipa_plist(ipa_file)
      ipa_info = nil
      begin
        IPA::IPAFile.open(ipa_file) do |ipa| 
          ipa_info = ipa.info
        end
      rescue Zip::ZipError

      end
      ipa_info
    end

    def create_app_directory(app_name, app_version)
      FileUtils.mkdir_p(@apps_dir.join(app_name,app_version))
    end

    def move_ipa_file(ipa_file, app_name, app_version)
      FileUtils.mv(ipa_file, @apps_dir.join(app_name,app_version,"#{app_name}-#{app_version}.ipa"))
    end

    def touch_digest_file(digest, app_name, app_version)
      FileUtils.touch(@apps_dir.join(app_name,app_version,"#{digest}.sha1"))
    end

    def calculate_digest(ipa_file)
      Digest::SHA1.hexdigest( File.read(ipa_file) )
    end

    def extract_icon_to_file(ipa_file, app_name, app_version)

      icon_destination = @apps_dir.join(app_name,app_version,"Icon.png")
      begin
        IPA::IPAFile.open(ipa_file) do |ipa| 
          File.open(icon_destination, 'wb') {|f| f.write ipa.icon }
        end
      rescue Zip::ZipError

      end
    end

    def extract_manifest(info_plist_hash)
      manifest = {}
      assets = [{'kind'=>'software-package', 'url'=>'__URL__'}]
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

    def write_manifest_to_file(manifest_hash, app_name, app_version)
      File.open(@apps_dir.join(app_name,app_version,'manifest.plist'), 'wb') {|f| f.write manifest_hash.to_plist }
    end

  end

end