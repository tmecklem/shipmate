require 'shipmate/ipa_importer'
require 'shipmate/apk_importer'

namespace :cron do

  desc "Import any apps waiting in the rails import directory"
  task :import_apps do
    importer = Shipmate::IpaImporter.new(Shipmate::Application.config.import_dir, Shipmate::Application.config.ios_dir)
    importer.import_apps
    android_importer = Shipmate::ApkImporter.new(Shipmate::Application.config.import_dir, Shipmate::Application.config.android_dir)
    android_importer.import_apps
  end
  
end