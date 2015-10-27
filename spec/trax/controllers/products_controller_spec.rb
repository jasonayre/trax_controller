require 'spec_helper'

::RSpec.describe ProductsController, :type => :controller do
  # routes { Admin::Engine.routes }
  # login_admin

  before(:all) do
    @product1 = ::Product.create(:name => "apple imac", :quantity => 0, :in_stock => false)
    @product2 = ::Product.create(:name => "apple macbook", :quantity => 2, :in_stock => true)
    @product3 = ::Product.create(:name => "apple ipod", :quantity => 3, :in_stock => true)
  end

  describe '#index' do
    it {
      get :index

      expect(response).to be_ok
      json = JSON.parse response.body
      expect(json).to have_key('products')
    }
  end

  # describe '#show' do
  #   let(:survey){ create(:census_survey) }
  #
  #   it 'shows' do
  #     get :show, id: survey.id
  #
  #     expect(response).to be_ok
  #     json = JSON.parse response.body
  #     expect(json).to have_key('survey')
  #   end
  # end
end
