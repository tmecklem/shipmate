require 'apktools/apkxml'
require 'nokogiri'

module Shipmate

  class ApkParser

  	attr_accessor :apk_name

  	def initialize apk_name
  		@apk_name = apk_name
  	end

  	def parse_manifest
  		xml = ApkXml.new(@apk_name)
		  manifest_xml = xml.parse_xml("AndroidManifest.xml", true, true)
		  xml_doc  = Nokogiri::XML(manifest_xml)

		  app_name = xml_doc.at_xpath("/manifest/application")["android:label"]
		  app_version = xml_doc.first_element_child.attributes["versionName"].value

		  {"app_name" => app_name, "app_version" => app_version}
  	end
  end

end