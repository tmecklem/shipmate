require 'spec_helper'

describe AppsController do

  let(:ios_dir) { Rails.root.join('public','apps','ios') }

  describe '#initialize' do

    it 'sets the ios_dir property' do
      apps_controller = AppsController.new
      expect(apps_controller.ios_dir).to_not eq nil
    end

  end

  describe 'before_action_detect_browser' do

    it 'assigns device_type to iPhone' do
      request.env['HTTP_USER_AGENT'] = "Apple-iPhone5C1/1001.525"
      get :index #representative action
      expect(assigns[:device_type]).to eq :iphone
    end

    it 'assigns device_type to iPhone for iPods' do
      request.env['HTTP_USER_AGENT'] = "Apple-iPod4C1/902.176"
      get :index
      expect(assigns[:device_type]).to eq :iphone
    end

    it 'assigns device_type to iPad' do
      request.env['HTTP_USER_AGENT'] = "Apple-iPad3C2/1001.523"
      get :index
      expect(assigns[:device_type]).to eq :ipad
    end

    it 'assigns device_type to Desktop' do
      request.env['HTTP_USER_AGENT'] = "Mozilla/5.0 (Windows NT 6.2; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/32.0.1667.0 Safari/537.36"
      get :index 
      expect(assigns[:device_type]).to eq :desktop
    end

  end

  describe 'GET #index' do

    before (:each) do
      FileUtils.mkdir_p(ios_dir.join('Chocolate'))
      FileUtils.mkdir_p(ios_dir.join('Monkeybread'))
    end

    after(:each) do
      FileUtils.rm_r(ios_dir.join('Chocolate'))
      FileUtils.rm_r(ios_dir.join('Monkeybread'))
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

    it 'creates a list of the ios_dir top level folders' do
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

end
