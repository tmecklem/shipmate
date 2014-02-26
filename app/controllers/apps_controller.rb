class AppsController < ApplicationController

  attr_accessor :apps_dir

  def initialize
    @apps_dir = Rails.root.join('public','apps')
    FileUtils.mkdir_p(@apps_dir)
    super
  end

  def index
    @app_names = subdirectories(@apps_dir).sort
  end

  def list_app_releases
    @app_name = params[:app_name]
    app_dir = @apps_dir.join(@app_name)
    app_builds = subdirectories(app_dir)
    
    app_builds.map! do |app_build|
      app_build.split('.')[0...-1].join('.')
    end
    app_builds.uniq!
    @app_releases = VersionSorter.rsort(app_builds)

  end

  def list_app_builds
    @app_name = params[:app_name]
    app_dir = @apps_dir.join(@app_name)
    app_builds = subdirectories(app_dir)

    app_builds.select! do |app_build|
      app_build.split('.')[0...-1].join('.').eql?(params[:app_release])
    end

    @release_builds = VersionSorter.rsort(app_builds)
  end

  def subdirectories(dir)
    Dir.entries(dir).select { |entry| File.directory?(File.join(dir, entry)) and not entry.eql?('.') and not entry.eql?('..') }
  end


end
