module Shipmate

  class IpaParser

    attr_accessor :ipa_file

    def initialize(ipa_file)
      @ipa_file = ipa_file
    end

    def parse_plist
      ipa_info = nil
      begin
        IPA::IPAFile.open(@ipa_file) do |ipa| 
          ipa_info = ipa.info
        end
      rescue Zip::ZipError => e
        puts e
      end
      ipa_info
    end

  end

end