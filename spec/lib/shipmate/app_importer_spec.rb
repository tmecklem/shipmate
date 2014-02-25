require 'spec_helper'
require 'shipmate/app_importer'

describe Shipmate::AppImporter do
  
  let(:import_dir) { Rails.root.join('public','import') }
  let(:apps_dir) { Rails.root.join('public','apps') }
  let(:importer) { Shipmate::AppImporter.new(import_dir, apps_dir) }

  describe '#initialize' do

    it 'stores the import folder as a property' do
      expect(importer.import_dir).to be import_dir
    end    

    it 'stores the apps folder as a property' do
      expect(importer.apps_dir).to be apps_dir
    end

  end

  describe 'import methods' do 

    let(:ipa_file_fixture) { Rails.root.join('spec','lib','shipmate','fixtures','iCare360Pad-12.ipa') }
    let(:import_ipa_file) { import_dir.join("iCare360Pad-12.ipa") }

    before(:each) do
      FileUtils.rm_rf(apps_dir.join("Care360 HD"))
      FileUtils.cp(ipa_file_fixture, import_ipa_file)
    end

    after(:each) do
      FileUtils.rm(import_ipa_file) if File.file?(import_ipa_file)
      FileUtils.rm_rf(apps_dir.join("Care360 HD"))
    end

    describe '#import_app' do

      let(:import_ipa_file) { import_dir.join("iCare360Pad-12.ipa") }

      it 'takes the location of an ipa file' do
        importer.import_app(import_ipa_file)
      end

    end

    describe '#parse_ipa_plist' do

      it 'returns a hash of important information from the ipa\'s info.plist file' do
        plist = importer.parse_ipa_plist(import_ipa_file)
        expect(plist["CFBundleDisplayName"]).to eq("Care360 HD")
        expect(plist["CFBundleName"]).to eq("iCare360Pad")
        expect(plist["CFBundleIdentifier"]).to eq("com.medplus.iCare360Pad")
        expect(plist["CFBundleVersion"]).to eq("2014.1.0.12")

      end

    end

    describe '#create_app_directory' do

      it 'creates a folder in the apps_dir with the given app_name and app_version' do
        importer.create_app_directory("Care360 HD","2014.1.0.12")
        expect(File.directory?(apps_dir.join("Care360 HD","2014.1.0.12"))).to be true
      end

    end

    describe '#move_ipa_file' do

      it 'moves an ipa file to the apps directory' do
        FileUtils.mkdir_p(apps_dir.join("Care360 HD","2014.1.0.12"))
        importer.move_ipa_file(import_ipa_file, "Care360 HD","2014.1.0.12")
        expect(File.file?(apps_dir.join("Care360 HD","2014.1.0.12", "Care360 HD-2014.1.0.12.ipa"))).to be true
      end

    end

    describe '#write_plist_info' do

      it 'writes a yaml of the given hash to the app directory' do
        FileUtils.mkdir_p(apps_dir.join("Care360 HD","2014.1.0.12"))
        
        sample_plist = {"CFBundleName"=>"iCare360Pad"}
        importer.write_plist_info(sample_plist, "Care360 HD","2014.1.0.12")
        file_contents = File.open(apps_dir.join("Care360 HD","2014.1.0.12","info.yaml"), "rb").read
        expect(file_contents).to include("CFBundleName: iCare360Pad")
      end

    end

  end

end