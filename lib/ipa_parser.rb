require 'ipa'

class IPAParser

  def initialize(ipa_file)
    @ipa_file = ipa_file
  end

  def plist_info(ipa_file)
    IPA::IPAFile.open(file_name) { |ipa| ipa.info } }
  end

end