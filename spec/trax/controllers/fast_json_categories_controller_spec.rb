require 'spec_helper'

::RSpec.describe ::FastJson::CategoriesController, :type => :controller do
  before(:all) do
    @shoes_category = ::Category.create!(:name => 'mens shoes')
    @watches_category = ::Category.create!(:name => 'mens watches')
    @apparels_category = ::Category.create!(:name => 'mens apparels')
    @shirts_category = @apparels_category.subcategories.create(:name => 'mens shirts')

    @product1 = ::Product.create!(:name => "DC Villan", :quantity => 0, :in_stock => false, :category => @shoes_category)
    @product2 = ::Product.create!(:name => "Nixon Rotolog", :quantity => 2, :in_stock => true, :category => @watches_category)
    @product3 = ::Product.create!(:name => "T-Shirt", :quantity => 3, :in_stock => true, :category => @apparels_category)
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

  context "overriding default resource actions and render resource" do
    describe "#show_without_products" do
      it {
        get :show_without_products, :id => @shoes_category.id
        json = ::JSON.parse(response.body)
        expect(json["category"]).to_not have_key('products')
      }
    end

    describe "#widget" do
      it "render resource can have resource passed to it" do
        get :widget, :id => @shoes_category.id
        json = ::JSON.parse(response.body)
        expect(json["category"]["name"]).to eq "whatever"
      end
    end

    describe "#widget_with_renamed_root" do
      it "allows root key to be overridden" do
        get :widget_with_renamed_root, :id => @shoes_category.id
        json = ::JSON.parse(response.body)
        expect(json["widget"]["name"]).to eq "whatever"
      end
    end

    describe "#show_by_calling_original_action" do
      it "allows show method itself to be called passing in overridden options" do
        get :show_by_calling_original_action, :id => @shoes_category.id
        json = ::JSON.parse(response.body)
        expect(json["show_by_calling_original_action"]["name"]).to eq @shoes_category.name
      end
    end

    describe "#product_with_category" do
      it "deeply serializes" do
        get :product_with_category, :id => @product3.id
        json = ::JSON.parse(response.body)
        expect(json["product"]).to eq(
          "name" => @product3.name,
          "category" => {
            "name" => @apparels_category.name,
            "subcategories" => [
              { "name" => @shirts_category.name,
                "subcategories" => []
              }
            ]
          }
        )
      end
    end
  end

  context '#create_with_modified_resource' do
    let(:widget_name) { 'My New Widget' }
    let(:widget_quantity) { 10 }
    let(:params){ {
      :format => :json,
      :widget => widget_params
    }}
    let(:widget_params) { { :name => widget_name, :quantity => widget_quantity } }
    before { post :create_with_modified_resource, params }

    context 'success' do
      it { expect(response).to be_successful }
      it {
        json = JSON.parse response.body
        expect(json).to have_key("widget")
      }
      it { expect(response.status).to eq 201 }
    end

    context 'failure' do
      let(:widget_name) { 'My New Widget' }
      let(:widget_quantity) { 0 }

      context 'default failure action' do
        before { post :create_with_modified_resource, params }

        it { expect(response).to_not be_successful }
        it {
          json = JSON.parse response.body
          expect(json["meta"]["errors"]).to have_key("quantity")
        }
        it { expect(response.status).to eq 422 }
      end
    end
  end

  context '#create' do
    let(:category_name) { 'My New Category'}
    let(:params){ {
      :format => :json,
      :category => category_params
    }}
    let(:category_params) { { :name => category_name } }

    context 'success' do
      context 'with default create action' do
        before { post :create, params }

        it { expect(response).to be_successful }
        it {
          json = JSON.parse response.body
          expect(json).to have_key("category")
        }
        it { expect(response.status).to eq 201 }
      end

      context 'allows overrides' do
        context 'response code override' do
          before { post :create_with_modified_response_codes, params }

          it { expect(response.status).to eq 202 }
        end
      end
    end

    context 'failure' do
      let(:category_name) { 'a' }

      context 'default create action' do
        before { post :create, params }

        it { expect(response).to_not be_successful }
        it {
          json = JSON.parse response.body
          expect(json["meta"]["errors"]).to have_key("name")
        }
        it { expect(response.status).to eq 422 }
      end

      context 'allows overrides' do
        context 'response code override' do
          before { post :create_with_modified_response_codes, params }

          it { expect(response.status).to eq 404 }
        end
      end
    end
  end

  context '#update' do
    let(:category) { ::Category.create(:name => category_name) }
    let(:category_name) { 'My New Category'}
    let(:new_category_name) { 'mynewcategoryname' }
    let(:params){ {
      :format => :json,
      :id => category.id,
      :category => category_params
    }}
    let(:category_params) { { :name => new_category_name } }

    context 'success' do
      context 'with default update action' do
        before { put(:update, params) }

        it { expect(response).to be_successful }
        it {
          json = JSON.parse response.body
          expect(json).to have_key("category")
        }
        it {
          json = JSON.parse response.body
          expect(json["category"]["name"]).to eq(new_category_name)
        }
        it { expect(response.status).to eq 200 }
      end
    end

    context 'failure' do
      let(:new_category_name) { 'a' }

      context 'default update action' do
        before { put :update, params }

        it { expect(response).to_not be_successful }
        it {
          json = JSON.parse response.body
          expect(json["meta"]["errors"]).to have_key("name")
        }
        it { expect(response.status).to eq 422 }
      end
    end
  end
end
