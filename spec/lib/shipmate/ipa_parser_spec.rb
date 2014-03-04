require 'spec_helper'
require 'shipmate/ipa_parser'

describe Shipmate::IpaParser do

  let(:ipa_file) { Rails.root.join('spec','fixtures','Go-Tomato-Ad-Hoc-27.ipa') }
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

end