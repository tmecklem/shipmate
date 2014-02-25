

module Shipmate

  class AppImporter

    attr_reader :import_dir, :apps_dir

    def initialize(import_dir, apps_dir)
      @import_dir = import_dir
      @apps_dir = apps_dir
    end

    def import_app(ipa_file)

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

    end

  end

end