require 'spec_helper'
require 'shipmate/ipa_parser'

describe Shipmate::IpaParser do

  let(:ipa_file) { Rails.root.join('spec','lib','shipmate','fixtures','Go-Tomato-Ad-Hoc-27.ipa') }
  let(:ipa_file_no_icon) { Rails.root.join('spec', 'lib', 'shipmate', 'fixtures', 'Tribes-101.ipa' )}
  let(:ipa_parser) { Shipmate::IpaParser.new(ipa_file) }
  let(:tmp_dir) { '/tmp/ipa_parser' }

  before(:each) do
    FileUtils.mkdir_p(tmp_dir)
  end

  after (:each) do
    FileUtils.rm_rf(tmp_dir)
  end

  describe '#initialize' do

    it 'stores a property of the ipa file' do
      expect(ipa_parser.ipa_file).to eq ipa_file
    end

  end

  describe '#parse_plist' do

    it 'returns a hash of important information from the ipa\'s info.plist file' do
      plist = ipa_parser.parse_plist
      expect(plist["CFBundleDisplayName"]).to eq("Go Tomato")
      expect(plist["CFBundleName"]).to eq("Go Tomato")
      expect(plist["CFBundleIdentifier"]).to eq("com.mecklem.Go-Tomato")
      expect(plist["CFBundleVersion"]).to eq("1.0.27")

    end

  end

  describe '#extract_icon_to_file' do

    it 'extracts a representative app icon from the ipa' do
      icon_path = Pathname.new(tmp_dir).join('Icon.png')
      ipa_parser.extract_icon_to_file(ipa_file,icon_path.to_s)
      expect(Digest::SHA1.hexdigest( File.read(icon_path) )).to eq "ae9535eb6575d2745b984df8447b976ffce9cc6a"
    end

  end

  describe '#extract_icon_to_file (default icon)' do
    it 'should set a default iOS icon when there is no icon to extract' do
      icon_path = Pathname.new(tmp_dir).join('Icon.png')
      ipa_parser.extract_icon_to_file(ipa_file_no_icon, icon_path.to_s)
      defaultIOSImageSHA1 = ""
      expect(Digest::SHA1.hexdigest( File.read(icon_path) )).to eq defaultIOSImageSHA1
    end
  end

  describe '#extract_manifest' do

    it 'returns a hash containing the manifest.plist content from info in the ipa' do
      info_plist_hash = {"CFBundleIdentifier"=>"com.mecklem.Go-Tomato", "CFBundleName"=>"Go Tomato", "CFBundleDisplayName"=>"Go Tomato", "CFBundleVersion"=>"1.0.27"}
      expected_manifest_plist_hash = {'items' => [ {'assets' => [ {'kind' => 'software-package', 'url' => '__URL__'}, {'kind'=>'display-image', 'needs-shine'=>false, 'url'=>'__URL__'} ], 'metadata' => {'bundle-identifier'=>'com.mecklem.Go-Tomato', 'bundle-version'=>'1.0.27', 'kind'=>'software', 'title'=>'Go Tomato 1.0.27', 'subtitle'=>'Go Tomato 1.0.27'} } ]}
      expect(ipa_parser.extract_manifest(info_plist_hash)).to eq expected_manifest_plist_hash
    end

  end

end
