require 'spec_helper'

::RSpec.describe ProductsController, :type => :controller do
  before(:all) do
    @product1 = ::Product.create(:name => "apple imac", :quantity => 0, :in_stock => false)
    @product2 = ::Product.create(:name => "apple macbook", :quantity => 2, :in_stock => true)
    @product3 = ::Product.create(:name => "apple ipod", :quantity => 3, :in_stock => true)
  end

  context '#index' do
    it {
      get :index
      expect(response).to be_ok
      json = JSON.parse response.body
      expect(json).to have_key('products')
    }

    context 'pagination' do
      ["current_page", "per_page", "size", "total_pages", "total_entries"].each do |k|
        it {
          get :index
          json = JSON.parse response.body
          expect(json["meta"]["pagination"]).to have_key(k)
        }
      end
    end
  end

  describe '#show' do
    it 'shows' do
      get :show, id: @product1.id

      expect(response).to be_ok
      json = JSON.parse response.body
      expect(json).to have_key('product')
    end
  end
end
