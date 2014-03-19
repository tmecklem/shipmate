require 'spec_helper'

describe AppsController do

  let(:ios_dir) { Rails.root.join('public','apps','ios') }
  let(:android_dir) {Rails.root.join('public', 'apps', 'android')}

  describe '#initialize' do

    it 'sets the ios_dir property' do
      apps_controller = AppsController.new
      expect(apps_controller.ios_dir).to_not eq nil
    end

    it 'sets the android_dir property' do
      apps_controller = AppsController.new
      expect(apps_controller.android_dir).to_not eq nil
    end

  end

  describe 'GET #index' do

    before (:each) do
      FileUtils.mkdir_p(ios_dir.join('Chocolate'))
      FileUtils.mkdir_p(ios_dir.join('Monkeybread'))
      FileUtils.mkdir_p(android_dir.join('Chocolate'))
      FileUtils.mkdir_p(android_dir.join('Monkeybread'))
    end

    after(:each) do
      FileUtils.rm_r(ios_dir.join('Chocolate'))
      FileUtils.rm_r(ios_dir.join('Monkeybread'))
      FileUtils.rm_r(android_dir.join('Chocolate'))
      FileUtils.rm_r(android_dir.join('Monkeybread'))
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

    it 'assigns a list of the ios apps' do
      get :index
      expect(assigns[:ios_app_names]).to include('Chocolate')
      expect(assigns[:ios_app_names]).to include('Monkeybread')
    end

    it 'assigns a list of the android apps' do
      get :index
      expect(assigns[:android_app_names]).to include('Chocolate')
      expect(assigns[:android_app_names]).to include('Monkeybread')
    end

    it 'does not include . or .. in ios app names listing' do
      get :index
      expect(assigns[:ios_app_names]).to_not include('.')
      expect(assigns[:ios_app_names]).to_not include('..')
    end
    
    it 'does not include . or .. in android app names listing' do
      get :index
      expect(assigns[:android_app_names]).to_not include('.')
      expect(assigns[:android_app_names]).to_not include('..')
    end

  end

end
