class AppsController < ApplicationController
  def list
    dir = Rails.root.join('public','apps')
    FileUtils.mkdir_p(dir)
    #@list = file_list(dir)
    @list = Dir.glob("#{dir}/**/*/")
  end

  def file_list(dir)
    Dir.entries(dir).reject { |entry| !entry.upcase.end_with?('IPA') }
  end

end
