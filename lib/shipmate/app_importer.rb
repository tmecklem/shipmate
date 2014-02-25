require 'yaml'

module Shipmate

  class AppImporter

    attr_reader :import_dir, :apps_dir

    def initialize(import_dir, apps_dir)
      @import_dir = import_dir
      @apps_dir = apps_dir
    end

    def import_app(ipa_file)
      plist_hash = parse_ipa_plist(ipa_file)
      app_name = plist_hash["CFBundleDisplayName"]
      app_version = plist_hash["CFBundleVersion"]
      create_app_directory(app_name, app_version)
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

  end

end