require 'spec_helper'

::RSpec.describe CategoriesController, :type => :controller do
  before(:all) do
    @shoes_category = ::Category.create(:name => 'mens shoes')
    @watches_category = ::Category.create(:name => 'mens watches')

    @product1 = ::Product.create(:name => "DC Villan", :quantity => 0, :in_stock => false, :category => @shoes_category)
    @product2 = ::Product.create(:name => "Nixon Rotolog", :quantity => 2, :in_stock => true, :category => @watches_category)
  end

  context '#index' do
    it {
      get :index
      expect(response).to be_ok
      json = ::JSON.parse(response.body)
      expect(json).to have_key('categories')
    }

    context "serialization of associations" do
      it {
        get :index
        json = ::JSON.parse(response.body)
        expect(json["categories"][0]).to_not have_key('products')
      }
    end
  end

  context "#show" do
    context "serialization of associations" do
      it {
        get :show, :id => @shoes_category.id
        json = ::JSON.parse(response.body)
        expect(json["category"]).to have_key('products')
        expect(json["category"]["products"][0]["name"]).to eq("DC Villan")
      }
    end
  end
end
