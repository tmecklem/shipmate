require 'spec_helper'

describe AndroidAppsController do

  let(:android_dir) { Rails.root.join('public','apps','android') }

  describe '#initialize' do
    it 'sets the android_dir property' do
      apps_controller = AndroidAppsController.new
      expect(apps_controller.android_dir).to_not eq nil
    end
  end

  describe 'GET #list_app_releases' do
    before (:each) do
      FileUtils.mkdir_p(android_dir.join('Vanilla','1.2.4.0'))
      FileUtils.mkdir_p(android_dir.join('Vanilla','1.2.4.10'))
      FileUtils.mkdir_p(android_dir.join('Vanilla','1.2.6.0'))
      FileUtils.mkdir_p(android_dir.join('Vanilla','1.2.2.0'))
    end

    after(:each) do
      FileUtils.rm_r(android_dir.join('Vanilla'))
    end

    it 'returns a 200' do
      get :list_app_releases, :app_name => 'Vanilla'
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it 'creates a list of reverse release sorted by app releases' do
      get :list_app_releases, :app_name => 'Vanilla'
      expect(assigns[:app_releases]).to eq ['1.2.6', '1.2.4', '1.2.2']
    end

    it 'creates a hash of the keys and the most recent builds as values' do
      app_name = 'Vanilla'
      get :list_app_releases, :app_name => app_name
      expect(assigns[:most_recent_build_hash]).to eq({'1.2.6'=>AppBuild.new(android_dir,app_name,'1.2.6.0'), '1.2.4'=>AppBuild.new(android_dir,app_name,'1.2.4.10'), '1.2.2'=>AppBuild.new(android_dir,app_name,'1.2.2.0')})
    end
  end

  describe 'GET #list_app_builds' do
    before (:each) do
      FileUtils.mkdir_p(android_dir.join('Vanilla','1.2.0.14'))
      FileUtils.mkdir_p(android_dir.join('Vanilla','1.2.0.12'))
      FileUtils.mkdir_p(android_dir.join('Vanilla','1.2.0.1'))
      FileUtils.mkdir_p(android_dir.join('Vanilla','1.2.3.goofy'))
      FileUtils.mkdir_p(android_dir.join('Vanilla','1.2.0.2'))
    end

    after(:each) do
      FileUtils.rm_r(android_dir.join('Vanilla'))
    end

    it 'returns a 200' do
      get :list_app_builds, :app_name => 'Vanilla', :app_release => '1.2.0'
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it 'assembles a reverse version sorted list of builds within a release' do
      app_name = 'Vanilla'
      get :list_app_builds, :app_name => app_name, :app_release => '1.2.0'
      expect(assigns[:app_builds]).to eq [AppBuild.new(android_dir,app_name,'1.2.0.14'),AppBuild.new(android_dir,app_name,'1.2.0.12'),AppBuild.new(android_dir,app_name,'1.2.0.2'),AppBuild.new(android_dir,app_name,'1.2.0.1')]
    end

    it 'assigns the app name' do
      get :list_app_builds, :app_name => 'Vanilla', :app_release => '1.2.0'
      expect(assigns[:app_name]).to eq 'Vanilla'
    end
  end

end