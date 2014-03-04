require 'spec_helper'

describe AppBuild do 
  
  let(:apps_dir) { Pathname.new("/tmp/models_tests") }
  let(:app_name) { "Go Tomato" }
  let(:build_version) { "1.0.27" }
  let(:app_build) {AppBuild.new(apps_dir, app_name, build_version)}
  let(:ipa_file_fixture) { Rails.root.join('spec','fixtures','Go-Tomato-Ad-Hoc-27.ipa') }
  let(:expected_build_file_root_path) { Pathname.new("/tmp/models_tests/Go Tomato/1.0.27") }
  let(:expected_ipa_file_location) { Pathname.new("/tmp/models_tests/Go Tomato/1.0.27/Go Tomato-1.0.27.ipa") }
    
  before(:each) do
    FileUtils.mkdir_p(expected_build_file_root_path)
    FileUtils.cp(ipa_file_fixture, expected_ipa_file_location)
  end

  after(:each) do
    FileUtils.rm_rf(apps_dir.to_s)
  end

  describe '#initialize' do

    it 'stores properties for the root apps_dir, app_name, and build_version that identify ' do
      expect(app_build.apps_dir).to eq(Pathname.new("/tmp/models_tests"))
      expect(app_build.app_name).to eq "Go Tomato"
      expect(app_build.build_version).to eq "1.0.27"
    end

  end

  describe '#build_file_root_path' do
    it 'returns the location of where the ipa file should be' do
      expect(app_build.build_file_root_path).to eq(expected_build_file_root_path)
    end
  end

  describe '#ipa_file_path' do
    it 'returns the location of the ipa file' do
      expect(app_build.ipa_file_path).to eq(expected_ipa_file_location)
    end
  end

  describe '#ipa_file?' do
    it 'returns true if the ipa file exists' do
      expect(app_build.ipa_file?).to be true
    end
    it 'returns false if the ipa file does not exist' do
      FileUtils.rm_rf(apps_dir.to_s)
      expect(app_build.ipa_file?).to be false
    end
  end

  describe '#ipa_checksum' do
    it 'returns a sha1 hash of the ipa file' do
      expect(app_build.ipa_checksum).to eq "45a5a4862ebcc0b80a3f5e1a60649734eebca18a"
    end
  end

  describe '#manifest_plist_hash' do
    it 'returns a Hash containing the proper structure and values for an iOS OTA manifest' do
      expected_manifest_plist_hash = {'items' => [ {'assets' => [ {'kind' => 'software-package', 'url' => '__URL__'}, {'kind'=>'display-image', 'needs-shine'=>false, 'url'=>'__URL__'} ], 'metadata' => {'bundle-identifier'=>'com.mecklem.Go-Tomato', 'bundle-version'=>'1.0.27', 'kind'=>'software', 'title'=>'Go Tomato 1.0.27', 'subtitle'=>'Go Tomato 1.0.27'} } ]}
      expect(app_build.manifest_plist_hash).to eq expected_manifest_plist_hash
    end
  end

  describe '#info_plist_hash' do
    it 'returns a hash of the ipa\'s info.plist file' do
      plist = app_build.info_plist_hash
      expect(plist["CFBundleDisplayName"]).to eq("Go Tomato")
      expect(plist["CFBundleName"]).to eq("Go Tomato")
      expect(plist["CFBundleIdentifier"]).to eq("com.mecklem.Go-Tomato")
      expect(plist["CFBundleVersion"]).to eq("1.0.27")

    end

  end

end