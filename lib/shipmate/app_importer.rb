require 'yaml'
require 'ipa'
require 'pathname'
require 'digest'

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
      move_ipa_file(ipa_file, app_name, app_version)
      write_plist_info(plist_hash, app_name, app_version)
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

    def write_plist_info(plist_hash, app_name, app_version)
      File.open(@apps_dir.join(app_name,app_version,'info.yaml'), 'w') {|f| f.write plist_hash.to_yaml }
    end

    def touch_digest_file(digest, app_name, app_version)
      FileUtils.touch(@apps_dir.join(app_name,app_version,"#{digest}.sha1"))
    end

    def calculate_digest(ipa_file)
      Digest::SHA1.hexdigest( File.read(ipa_file) )
    end

  end

end