require 'yaml'
require 'ipa'
require 'pathname'
require 'digest'
require 'shipmate/ipa_parser'

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
        rescue StandardError => e
          puts "Unable to import #{ipa_file}: #{e}"
        end
      end
    end

    def import_app(ipa_file)
      ipa_parser = Shipmate::IpaParser.new(ipa_file)
      plist_hash = ipa_parser.parse_plist
      app_name = plist_hash["CFBundleDisplayName"]
      app_version = plist_hash["CFBundleVersion"]
      create_app_directory(app_name, app_version)
      touch_digest_file(calculate_digest(ipa_file), app_name, app_version)
      ipa_parser.extract_icon_to_file(ipa_file, @apps_dir.join(app_name,app_version,"Icon.png"))
      move_ipa_file(ipa_file, app_name, app_version)
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

  end

end