require 'shipmate/app_importer'

namespace :cron do

  desc "Import any apps waiting in the rails import directory"
  task :import_apps do
    importer = Shipmate::AppImporter.new(Shipmate::Application.config.import_dir, Shipmate::Application.config.ios_dir)
    importer.import_apps
  end
  
end