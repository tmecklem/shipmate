require 'spec_helper'
require 'shipmate/apk_import_strategy'

describe Shipmate::ApkImportStrategy do

  let(:tmp_root) { Pathname.new(Dir.mktmpdir) }
  let(:import_dir) { tmp_root.join('public','import') }
  let(:apps_dir) { tmp_root.join('public','apps') }
  let(:apk_importer) { Shipmate::ApkImportStrategy.new(import_dir, apps_dir) }

  after(:each) do
    FileUtils.remove_entry_secure tmp_root
  end

  describe "#initialize" do
    
    it 'stores the import folder as a property' do
      expect(apk_importer.import_dir).to eq import_dir
    end

    it 'makes sure the import directory exists' do
      expect(File.directory?(apk_importer.import_dir)).to be true
    end

    it 'stores the app folder as a property' do
      expect(apk_importer.apps_dir).to eq apps_dir
    end

    it 'makes sure the apps directory exists' do
      expect(File.directory?(apk_importer.apps_dir)).to be true
    end

    describe "import methods" do

      let(:apk_file_fixture) { Rails.root.join('spec','fixtures','ChristmasConspiracy.apk') }
      let(:import_apk_file) { import_dir.join("ChristmasConspiracy.apk") }
 
      before(:each) do
        FileUtils.mkdir_p import_dir
        FileUtils.rm_rf(apps_dir.join("Christmas Conspiracy"))
        FileUtils.cp(apk_file_fixture, import_apk_file)
      end

      after(:each) do
        FileUtils.rm(import_apk_file) if File.file?(import_apk_file)
        FileUtils.rm_rf(apps_dir.join("Christmas Conspiracy"))
      end

      describe '#create_app_directory' do
        it 'creates a folder in the apps_dir with the given app_name and app_version' do
          apk_importer.create_app_directory("Christmas Conspiracy", "4.2.55")
          expect(File.directory?(apps_dir.join("Christmas Conspiracy", "4.2.55"))).to be true
        end
      end

      describe '#move_apk_file' do
        it 'moves an apk file to the apps directory' do
          FileUtils.mkdir_p(apps_dir.join("Christmas Conspiracy", "4.2.55"))
          apk_importer.move_apk_file(import_apk_file, "Christmas Conspiracy", "4.2.55")
          expect(File.file?(apps_dir.join("Christmas Conspiracy", "4.2.55", "Christmas Conspiracy-4.2.55.apk"))).to be true
        end
      end

      describe '#import_app' do
        it 'takes the location of an apk file and... does the import' do
          apk_importer.import_app(import_apk_file)

          expect(File.directory?(apps_dir.join("Christmas Conspiracy", "1.0"))).to be true
          expect(File.file?(apps_dir.join("Christmas Conspiracy", "1.0", "Christmas Conspiracy-1.0.apk"))).to be true
        end

      end

    end

  end
end