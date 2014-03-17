require 'spec_helper'

describe AppBuild do 

  let(:apps_dir) { Pathname.new(Dir.mktmpdir) }
  let(:app_name) { "Go Tomato" }
  let(:build_version) { "1.0.27" }
  let(:app_build) {AppBuild.new(apps_dir, app_name, build_version)}
  let(:expected_build_file_root_path) { Pathname.new("#{apps_dir}/Go Tomato/1.0.27") }

  describe '#initialize' do

    it 'stores properties for the root apps_dir, app_name, and build_version that identify ' do
      expect(app_build.apps_dir).to eq(apps_dir)
      expect(app_build.app_name).to eq "Go Tomato"
      expect(app_build.build_version).to eq "1.0.27"
    end

  end

  describe '#build_file_root_path' do
    it 'returns the location of where the ipa file should be' do
      expect(app_build.build_file_root_path).to eq(expected_build_file_root_path)
    end
  end
end