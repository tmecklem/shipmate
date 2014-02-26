require 'spec_helper'
require 'shipmate/app_importer'

describe Shipmate::AppImporter do
    
  let(:tmp_root) { Pathname.new('/tmp/importer') }
  let(:import_dir) { tmp_root.join('public','import') }
  let(:apps_dir) { tmp_root.join('public','apps') }
  let(:importer) { Shipmate::AppImporter.new(import_dir.to_s, apps_dir.to_s) }

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
        expect(File.file?(apps_dir.join("Go Tomato","1.0.27", "45a5a4862ebcc0b80a3f5e1a60649734eebca18a.sha1"))).to be true      
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

    describe '#calculate_digest' do

      it 'calculates a sha1 digest of the ipa file' do
        sha1 = importer.calculate_digest(import_ipa_file)
        expect(sha1).to eq "45a5a4862ebcc0b80a3f5e1a60649734eebca18a"
      end

    end

    describe '#extract_icon' do

      it 'extracts a representative app icon from the ipa' do
        FileUtils.mkdir_p(apps_dir.join("Go Tomato","1.0.27"))
        importer.extract_icon_to_file(import_ipa_file,"Go Tomato","1.0.27")
        expect(Digest::SHA1.hexdigest( File.read(apps_dir.join("Go Tomato","1.0.27", "Icon.png")) )).to eq "1a7e6897814006c1001b4bf60d6e2a05a99e3cac"
      end

    end

  end

end