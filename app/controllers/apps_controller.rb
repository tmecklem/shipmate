class AppsController < ApplicationController
  def list
    dir = Rails.root.join('public','apps')
    FileUtils.mkdir_p(dir)
    #@list = file_list(dir)
    @list = Dir.glob("#{dir}/**/*/")
  end

  def show_versions
    app_name = params[:app_name]
    plists = app_plists(app_name)

    all_versions = plists.collect do |plist| 
      version_parts = plist["CFBundleVersion"].split('.')
      version_parts[0...-1].join('.')
    end

    @versions = all_versions.uniq

  end

  def file_list(dir)
    Dir.glob("#{dir}/**/*").reject { |entry| !entry.upcase.end_with?('IPA') }
  end

  def app_plists(app_name)
    dir = Rails.root.join('public','apps',app_name)
    plists = file_list(dir).collect do |ipa_file|
      plist_info(dir.join(ipa_file))
    end
  end

  def plist_info(ipa_file)
    ipa_info = nil
    IPA::IPAFile.open(ipa_file) do |ipa| 
      ipa_info = ipa.info
    end
    ipa_info
  end


end
