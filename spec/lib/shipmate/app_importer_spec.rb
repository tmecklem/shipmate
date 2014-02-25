require 'spec_helper'
require 'shipmate/app_importer'

describe Shipmate::AppImporter do
    
  let(:import_dir) { @tmp_root.join('public','import') }
  let(:apps_dir) { @tmp_root.join('public','apps') }
  let(:importer) { Shipmate::AppImporter.new(import_dir.to_s, apps_dir.to_s) }

  before(:all) do
    @tmp_root = Pathname.new('/tmp/importer')
    FileUtils.mkdir_p(@tmp_root)
  end

  after(:all) do
    FileUtils.rm_rf(@tmp_root)
  end

  describe '#initialize' do

    it 'stores the import folder as a property' do
      expect(importer.import_dir).to eq import_dir
    end    

    it 'makes sure the import directory exists' do
      expect(File.directory?(importer.import_dir)).to eq true
    end

    it 'stores the import folder as a property' do
      expect(importer.import_dir).to eq import_dir
    end

    it 'makes sure the apps directory exists' do
      expect(File.directory?(importer.apps_dir)).to eq true
    end

  end

  describe 'import methods' do 

    let(:ipa_file_fixture) { Rails.root.join('spec','lib','shipmate','fixtures','Go-Tomato-Ad-Hoc-27.ipa') }
    let(:import_ipa_file) { import_dir.join("Go-Tomato-Ad-Hoc-27.ipa") }

    before(:each) do
      FileUtils.rm_rf(apps_dir.join("Go Tomato"))
      FileUtils.cp(ipa_file_fixture, import_ipa_file)
    end

    after(:each) do
      FileUtils.rm(import_ipa_file) if File.file?(import_ipa_file)
      FileUtils.rm_rf(apps_dir.join("Go Tomato"))
    end

    describe '#import_app' do

      let(:import_ipa_file) { import_dir.join("Go-Tomato-Ad-Hoc-27.ipa") }

      it 'takes the location of an ipa file and... does the import' do
        importer.import_app(import_ipa_file)

        expect(File.directory?(apps_dir.join("Go Tomato","1.0.27"))).to be true
        expect(File.file?(apps_dir.join("Go Tomato","1.0.27", "Go Tomato-1.0.27.ipa"))).to be true
        file_contents = File.open(apps_dir.join("Go Tomato","1.0.27","info.yaml"), "rb").read
        expect(file_contents).to include("CFBundleIdentifier: com.mecklem.Go-Tomato")      
      end

    end

    describe '#parse_ipa_plist' do

      it 'returns a hash of important information from the ipa\'s info.plist file' do
        plist = importer.parse_ipa_plist(import_ipa_file)
        expect(plist["CFBundleDisplayName"]).to eq("Go Tomato")
        expect(plist["CFBundleName"]).to eq("Go Tomato")
        expect(plist["CFBundleIdentifier"]).to eq("com.mecklem.Go-Tomato")
        expect(plist["CFBundleVersion"]).to eq("1.0.27")

      end

    end

    describe '#create_app_directory' do

      it 'creates a folder in the apps_dir with the given app_name and app_version' do
        importer.create_app_directory("Go Tomato","1.0.27")
        expect(File.directory?(apps_dir.join("Go Tomato","1.0.27"))).to be true
      end

    end

    describe '#move_ipa_file' do

      it 'moves an ipa file to the apps directory' do
        FileUtils.mkdir_p(apps_dir.join("Go Tomato","1.0.27"))
        importer.move_ipa_file(import_ipa_file, "Go Tomato","1.0.27")
        expect(File.file?(apps_dir.join("Go Tomato","1.0.27", "Go Tomato-1.0.27.ipa"))).to be true
      end

    end

    describe '#write_plist_info' do

      it 'writes a yaml of the given hash to the app directory' do
        FileUtils.mkdir_p(apps_dir.join("Go Tomato","1.0.27"))
        sample_plist = {"CFBundleName"=>"iCare360Pad"}
        importer.write_plist_info(sample_plist, "Go Tomato","1.0.27")
        file_contents = File.open(apps_dir.join("Go Tomato","1.0.27","info.yaml"), "rb").read
        expect(file_contents).to include("CFBundleName: iCare360Pad")
      end

    end

  end

end