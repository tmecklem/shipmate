module Shipmate
  module AppImporter

    def import_apps
      app_files = Dir.glob("#{@import_dir}/**/*").reject { |entry| !entry.upcase.end_with?(app_extension.upcase) }
      app_files.each do |app_file|
        begin
          import_app app_file
        rescue StandardError => e
          puts "Unable to import #{app_file}: #{e}"
        end
      end
    end

  end
end