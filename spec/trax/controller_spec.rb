require 'rails_helper'

describe 'Trax::Controller', :type => :controller do
  controller do
    include Trax::Controller

    defaults :resource_class => Test::Model

    def resource_serializer
      Test::ModelSerializer
    end
  end

  describe 'GET #index' do
    it 'is ok' do
      get :index
      expect(response).to be_ok
    end

    it 'keys collection to controller_name' do
      get :index
      json = JSON.parse response.body
      ids = json[controller.controller_name].map{|i| i['id']}.sort
      expect(ids).to eq(Test::Model.all.map(&:id).sort)
    end

    it 'includes meta' do
      get :index
      json = JSON.parse response.body
      expect(json).to have_key('meta')
    end
  end
end
