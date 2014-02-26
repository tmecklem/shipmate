require 'spec_helper'

describe AppsController do

  let(:apps_dir) { Rails.root.join('public','apps') }

  describe '#initialize' do

    it 'sets the apps_dir property' do
      apps_controller = AppsController.new
      expect(apps_controller.apps_dir).to_not eq nil
    end

  end

  describe 'GET #index' do

    before (:each) do
      FileUtils.mkdir_p(apps_dir.join('Chocolate'))
      FileUtils.mkdir_p(apps_dir.join('Monkeybread'))
    end

    after(:each) do
      FileUtils.rm_r(apps_dir.join('Chocolate'))
      FileUtils.rm_r(apps_dir.join('Monkeybread'))
    end

    it 'returns a 200' do
      get :index
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end

    it 'creates a list of the apps_dir top level folders' do
      get :index
      expect(assigns[:app_names]).to include('Chocolate')
      expect(assigns[:app_names]).to include('Monkeybread')
    end

    it 'does not include . or .. in app names listing' do
      get :index
      expect(assigns[:app_names]).to_not include('.')
      expect(assigns[:app_names]).to_not include('..')
    end
  
  end

  describe 'GET #list_app_releases' do
    before (:each) do
      FileUtils.mkdir_p(apps_dir.join('Chocolate','1.2.4.0'))
      FileUtils.mkdir_p(apps_dir.join('Chocolate','1.2.4.10'))
      FileUtils.mkdir_p(apps_dir.join('Chocolate','1.2.6.0'))
      FileUtils.mkdir_p(apps_dir.join('Chocolate','1.2.2.0'))
    end

    after(:each) do
      FileUtils.rm_r(apps_dir.join('Chocolate'))
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

  end

  describe 'GET #list_app_builds' do
    before (:each) do
      FileUtils.mkdir_p(apps_dir.join('Chocolate','1.2.0.14'))
      FileUtils.mkdir_p(apps_dir.join('Chocolate','1.2.0.12'))
      FileUtils.mkdir_p(apps_dir.join('Chocolate','1.2.0.1'))
      FileUtils.mkdir_p(apps_dir.join('Chocolate','1.2.3.goofy'))
      FileUtils.mkdir_p(apps_dir.join('Chocolate','1.2.0.2'))
    end

    after(:each) do
      FileUtils.rm_r(apps_dir.join('Chocolate'))
    end

    it 'returns a 200' do
      get :list_app_builds, :app_name => 'Chocolate', :app_release => '1.2.0'
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it 'assembles a reverse version sorted list of builds within a release' do
      get :list_app_builds, :app_name => 'Chocolate', :app_release => '1.2.0'
      expect(assigns[:release_builds]).to eq ['1.2.0.14','1.2.0.12','1.2.0.2','1.2.0.1']
    end

    it 'assigns the app_name' do
      get :list_app_builds, :app_name => 'Chocolate', :app_release => '1.2.0'
      expect(assigns[:app_name]).to eq 'Chocolate'
    end

  end

end
