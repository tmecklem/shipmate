require 'shipmate/apk_parser'

module Shipmate

  class ApkImportStrategy

    attr_reader :import_dir, :apps_dir

    def app_extension
      "apk"
    end

    def initialize import_dir, apps_dir
      @import_dir = import_dir
      @apps_dir = apps_dir

      FileUtils.mkdir_p(@import_dir)
      FileUtils.mkdir_p(@apps_dir)
    end

    def create_app_directory app_name, app_version 
      FileUtils.mkdir_p(@apps_dir.join(app_name, app_version))
    end

    def move_apk_file apk_file, app_name, app_version
      FileUtils.mv(apk_file, @apps_dir.join(app_name, app_version, "#{app_name}-#{app_version}.apk")) 
    end

    def import_app apk_file
      apk_parser = Shipmate::ApkParser.new(apk_file)
      app_name = apk_parser.parse_manifest["app_name"]
      app_version = apk_parser.parse_manifest["app_version"]

      create_app_directory app_name, app_version
      move_apk_file apk_file, app_name, app_version
    end

  end

end