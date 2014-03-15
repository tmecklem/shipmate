require 'spec_helper'

describe IosAppsController do

  let(:ios_dir) { Rails.root.join('public','apps','ios') }

  describe '#initialize' do

    it 'sets the ios_dir property' do
      apps_controller = IosAppsController.new
      expect(apps_controller.ios_dir).to_not eq nil
    end

  end

  describe 'GET #list_app_releases' do
    before (:each) do
      FileUtils.mkdir_p(ios_dir.join('Chocolate','1.2.4.0'))
      FileUtils.mkdir_p(ios_dir.join('Chocolate','1.2.4.10'))
      FileUtils.mkdir_p(ios_dir.join('Chocolate','1.2.6.0'))
      FileUtils.mkdir_p(ios_dir.join('Chocolate','1.2.2.0'))
      FileUtils.touch(ios_dir.join('Chocolate','something.mobileprovision'))
    end

    after(:each) do
      FileUtils.rm_r(ios_dir.join('Chocolate'))
    end

    it 'returns a 200' do
      get :list_app_releases, :app_name => 'Chocolate'
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it 'creates a list of reverse release sorted app releases' do
      get :list_app_releases, :app_name => 'Chocolate'
      expect(assigns[:app_releases]).to eq ['1.2.6', '1.2.4', '1.2.2']
    end

    it 'creates a hash of releases as keys and the most recent builds as values' do
      app_name = 'Chocolate'
      get :list_app_releases, :app_name => app_name
      expect(assigns[:most_recent_build_hash]).to eq({'1.2.6'=>AppBuild.new(ios_dir,app_name,'1.2.6.0'), '1.2.4'=>AppBuild.new(ios_dir,app_name,'1.2.4.10'), '1.2.2'=>AppBuild.new(ios_dir,app_name,'1.2.2.0')})
    end

    it 'assigns @mobileprovision as a url if a mobileprovision file exists in the app root directory' do
      app_name = 'Chocolate'
      get :list_app_releases, :app_name => app_name
      expect(assigns[:mobileprovision]).to include("/something.mobileprovision")
    end

  end

  describe 'GET #list_app_builds' do
    before (:each) do
      FileUtils.mkdir_p(ios_dir.join('Chocolate','1.2.0.14'))
      FileUtils.mkdir_p(ios_dir.join('Chocolate','1.2.0.12'))
      FileUtils.mkdir_p(ios_dir.join('Chocolate','1.2.0.1'))
      FileUtils.mkdir_p(ios_dir.join('Chocolate','1.2.3.goofy'))
      FileUtils.mkdir_p(ios_dir.join('Chocolate','1.2.0.2'))
    end

    after(:each) do
      FileUtils.rm_r(ios_dir.join('Chocolate'))
    end

    it 'returns a 200' do
      get :list_app_builds, :app_name => 'Chocolate', :app_release => '1.2.0'
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it 'assembles a reverse version sorted list of builds within a release' do
      app_name = 'Chocolate'
      get :list_app_builds, :app_name => app_name, :app_release => '1.2.0'
      expect(assigns[:app_builds]).to eq [AppBuild.new(ios_dir,app_name,'1.2.0.14'),AppBuild.new(ios_dir,app_name,'1.2.0.12'),AppBuild.new(ios_dir,app_name,'1.2.0.2'),AppBuild.new(ios_dir,app_name,'1.2.0.1')]
    end

    it 'assigns the app_name' do
      get :list_app_builds, :app_name => 'Chocolate', :app_release => '1.2.0'
      expect(assigns[:app_name]).to eq 'Chocolate'
    end

  end

  describe 'single build methods' do

    before(:each) do
      FileUtils.mkdir_p(ios_dir.join('Go Tomato','1.0.27'))
      FileUtils.cp(Rails.root.join('spec','fixtures','Go-Tomato-Ad-Hoc-27.ipa'), ios_dir.join('Go Tomato','1.0.27','Go Tomato-1.0.27.ipa'))
    end

    after(:each) do
      FileUtils.rm_rf(ios_dir.join('Go Tomato'))
    end

    describe 'GET #show_build' do

      it 'returns a 200' do
        get :show_build, :app_name => 'Go Tomato', :build_version => '1.0.27'
        expect(response).to be_success
        expect(response.status).to eq(200)
      end

      it 'sets @app_build' do
        app_name = 'Go Tomato'
        build_version = '1.0.27'
        get :show_build, :app_name => app_name, :build_version => build_version
        expect(assigns[:app_build]).to eq AppBuild.new(ios_dir, app_name, build_version)
      end

    end

    describe 'GET #show_build_manifest' do

      before(:each) do
        request.env["HTTP_ACCEPT"] = 'text/plist'
      end

      it 'returns a 200' do
        get :show_build_manifest, :app_name => 'Go Tomato', :build_version => '1.0.27'
        expect(response).to be_success
        expect(response.status).to eq(200)
      end

      it 'set @app_name' do
        get :show_build_manifest, :app_name => 'Go Tomato', :build_version => '1.0.27'
        expect(assigns[:app_name]).to eq 'Go Tomato'
      end

      it 'returns a plist file' do 
        get :show_build_manifest, :app_name => 'Go Tomato', :build_version => '1.0.27'
        expect(response.body).to include("Go Tomato")
        expect(response.body).to include("1.0.27")
        expect(response.body).to include("software")
        expect(response.body).to include("url")
      end

    end
  end

end
