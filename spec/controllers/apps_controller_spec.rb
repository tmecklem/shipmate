require 'spec_helper'

describe AppsController do

  let(:apps_dir) { Rails.root.join('public','apps') }

  describe '#initialize' do

    it 'sets the apps_dir property' do
      apps_controller = AppsController.new
      expect(apps_controller.apps_dir).to_not eq nil
    end

  end

  describe 'GET #list' do

    before (:each) do
      FileUtils.mkdir_p(apps_dir.join('Chocolate'))
      FileUtils.mkdir_p(apps_dir.join('Monkeybread'))
    end

    after(:each) do
      FileUtils.rm_r(apps_dir.join('Chocolate'))
      FileUtils.rm_r(apps_dir.join('Monkeybread'))
    end

    it 'returns a 200' do
      get :list
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "renders the list template" do
      get :list
      expect(response).to render_template("list")
    end

    it 'creates a list of the apps_dir top level folders' do
      get :list
      expect(assigns[:app_names]).to include('Chocolate')
      expect(assigns[:app_names]).to include('Monkeybread')
    end

    it 'does not include . or .. in app names listing' do
      get :list
      expect(assigns[:app_names]).to_not include('.')
      expect(assigns[:app_names]).to_not include('..')
    end
  
  end

end
