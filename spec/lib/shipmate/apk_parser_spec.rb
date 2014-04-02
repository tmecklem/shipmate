require 'spec_helper'
require 'shipmate/apk_parser'

describe Shipmate::ApkParser do

  	let(:apk_file) { Rails.root.join('spec','fixtures','ChristmasConspiracy.apk') }
  	let(:apk_parser) { Shipmate::ApkParser.new(apk_file) }

	describe "#initialize" do
		it 'stores a property of the apk file' do
			expect(apk_parser.apk_name.to_s).to include("ChristmasConspiracy.apk")
		end
	end

	describe "#parse_manifest" do

		it 'returns a hash' do
			expect(apk_parser.parse_manifest).to_not eq nil
		end

		it 'returns a Hash containing the correct app name' do
			expect(apk_parser.parse_manifest["app_name"]).to eq "Christmas Conspiracy"
		end

		it 'returns a Hash containing the correct app version' do
			expect(apk_parser.parse_manifest["app_version"]).to eq "1.0"
		end
	end
 
end