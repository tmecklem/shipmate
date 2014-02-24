require 'spec_helper'

describe AppsController do

  describe '#initialize' do

    let(:apps_controller) { AppsController.new }

    it 'sets the apps_dir property' do
      apps_controller.apps_dir.should_not be_nil
    end

    it 'ensures the apps_dir exists' do
      Dir.exists?(apps_controller.apps_dir) #not great, since the folder might have existed before the initialize method was called
    end

  end

end
