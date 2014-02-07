class AppListingController < ApplicationController
  def index
    dir = Rails.root.join('public','apps')
    @list = file_list(dir)

  end

  def file_list(dir)
    Dir.entries(dir).reject { |entry| !entry.upcase.end_with?('IPA') }
  end
end
