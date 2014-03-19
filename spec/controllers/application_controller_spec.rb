require 'spec_helper'

describe ApplicationController do

  controller do
    def index
      render :text => 'good'
    end
  end

  describe 'before_action_detect_browser' do

    it 'assigns device_type to iPhone' do
      request.env['HTTP_USER_AGENT'] = "Apple-iPhone5C1/1001.525"
      get :index
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

    it 'assigns device_type to Android' do
      request.env['HTTP_USER_AGENT'] = "Mozilla/5.0 (Linux; Android 4.2.1; en-us; Nexus 4 Build/JOP40D) AppleWebKit/535.19 (KHTML, like Gecko) Chrome/18.0.1025.166 Mobile Safari/535.19"
      get :index
      expect(assigns[:device_type]).to eq :android
    end

  end

end