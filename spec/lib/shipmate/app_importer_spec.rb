require 'spec_helper'
require 'shipmate/app_importer'

describe Shipmate::AppImporter do
    
  let(:tmp_root) { Pathname.new(Dir.mktmpdir) }
  let(:import_dir) { tmp_root.join('public','import') }
  let(:apps_dir) { tmp_root.join('public','apps') }
  let(:importer) { Shipmate::AppImporter.new(import_dir.to_s, apps_dir.to_s) }

  after(:each) do
    FileUtils.remove_entry_secure tmp_root
  end

  describe '#initialize' do

    it 'stores the import folder as a property' do
      expect(importer.import_dir).to eq import_dir
    end    

    it 'makes sure the import directory exists' do
      expect(File.directory?(importer.import_dir)).to eq true
    end

    it 'stores the apps folder as a property' do
      expect(importer.apps_dir).to eq apps_dir
    end

    it 'makes sure the apps directory exists' do
      expect(File.directory?(importer.apps_dir)).to eq true
    end

  end

  describe 'import methods' do 

    let(:ipa_file_fixture) { Rails.root.join('spec','fixtures','Go-Tomato-Ad-Hoc-27.ipa') }
    let(:import_ipa_file) { import_dir.join("Go-Tomato-Ad-Hoc-27.ipa") }

    before(:each) do
      FileUtils.mkdir_p import_dir
      FileUtils.rm_rf(apps_dir.join("Go Tomato"))
      FileUtils.cp(ipa_file_fixture, import_ipa_file)
    end

    describe '#import_app' do

      let(:import_ipa_file) { import_dir.join("Go-Tomato-Ad-Hoc-27.ipa") }

      it 'takes the location of an ipa file and... does the import' do
        importer.import_app(import_ipa_file)

        expect(File.directory?(apps_dir.join("Go Tomato","1.0.27"))).to be true
        expect(File.file?(apps_dir.join("Go Tomato","1.0.27", "Go Tomato-1.0.27.ipa"))).to be true
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

  end

end