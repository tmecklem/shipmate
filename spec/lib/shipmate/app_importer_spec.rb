require 'spec_helper'
require 'shipmate/app_importer'
require 'shipmate/apk_import_strategy'
require 'shipmate/ipa_import_strategy'

describe Shipmate::AppImporter do

  let(:tmp_root) { Pathname.new(Dir.mktmpdir) }
  let(:import_dir) { tmp_root.join('public','import') }
  let(:apps_dir) { tmp_root.join('public','apps') }
  let(:importer) { Shipmate::AppImporter.new }
  
  before(:each) do
    FileUtils.remove_entry_secure tmp_root
    FileUtils.mkdir_p import_dir
  end

  after(:each) do
    FileUtils.remove_entry_secure tmp_root
  end

  describe 'Android import' do
  
    let(:apk_file_fixture) { Rails.root.join('spec','fixtures','ChristmasConspiracy.apk') }
    let(:import_apk_file) { import_dir.join("ChristmasConspiracy.apk") }
 
    before(:each) do
      FileUtils.cp(apk_file_fixture, import_apk_file)
    end

    it 'searches the import directory and imports android apps found there' do
      importer.add_strategy(Shipmate::ApkImportStrategy.new(import_dir, apps_dir))
      importer.import_apps

      expect(File.directory?(apps_dir.join("Christmas Conspiracy", "1.0"))).to be true
      expect(File.file?(apps_dir.join("Christmas Conspiracy", "1.0", "Christmas Conspiracy-1.0.apk"))).to be true
    end
  end

  describe 'iOS import' do

    let(:ipa_file_fixture) { Rails.root.join('spec','fixtures','Go-Tomato-Ad-Hoc-27.ipa') }
    let(:import_ipa_file) { import_dir.join("Go-Tomato-Ad-Hoc-27.ipa") }

    before(:each) do
      FileUtils.cp(ipa_file_fixture, import_ipa_file)
    end

    it 'searches the import directory and imports iOS apps found there' do
      importer.add_strategy(Shipmate::IpaImportStrategy.new(import_dir, apps_dir))
      importer.import_apps

      expect(File.directory?(apps_dir.join("Go Tomato","1.0.27"))).to be true
      expect(File.file?(apps_dir.join("Go Tomato","1.0.27", "Go Tomato-1.0.27.ipa"))).to be true
    end

  end

end