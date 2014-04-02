require 'shipmate/app_importer'
require 'shipmate/apk_import_strategy'
require 'shipmate/ipa_import_strategy'

namespace :cron do

  desc "Import any apps waiting in the rails import directory"
  task :import_apps do
    importer = Shipmate::AppImporter.new
    importer.add_strategy Shipmate::IpaImportStrategy.new(Shipmate::Application.config.import_dir, Shipmate::Application.config.ios_dir)
    importer.add_strategy Shipmate::ApkImportStrategy.new(Shipmate::Application.config.import_dir, Shipmate::Application.config.android_dir)
    importer.import_apps
  end
  
end