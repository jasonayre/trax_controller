require 'spec_helper'

describe Trax::Controller::Serialization::Adapters::Json do
  let(:category_flat_heads){ ::Category.new(:name => "flat heads") }
  let(:category_screwdrivers){ ::Category.new(:name => "screwdrivers", :subcategories => [category_flat_heads]) }
  let(:category_knives){ ::Category.new(:name => "knives") }
  let(:category_tools){ ::Category.new(:name => "tools", :subcategories => [category_screwdrivers, category_knives]) }
  let(:product_tool){ ::Product.new(:name => "Generics Multi-Purpose Tool", :category => category_tools) }
  let(:root_key){ 'root_key' }
  let(:serializer){ ::ProductWithCategorySerializer.new(product_tool, :root => root_key) }
  let!(:expected_root_key){ root_key.to_sym }
  let!(:expected_tool_hash){ {
    :name => product_tool.name,
    :category => {
      :name => category_tools.name,
      :subcategories => [
        { :name => category_screwdrivers.name,
          :subcategories => [{:name => category_flat_heads.name, :subcategories => []}]
        },
        {:name => category_knives.name, :subcategories => []}
      ]
    }
  }}

  subject(:serialized){ described_class.new(serializer).serializable_hash }

  it { expect(serialized).to eq(expected_root_key => expected_tool_hash) }

  context "collection" do
    let(:category_cookware){ ::Category.new(:name => "cookware") }
    let(:product_pot){ ::Product.new(:name => "Pot", :category => category_cookware) }
    let(:collection){ [product_tool, product_pot] }
    let(:root_key){ 'root_keys' }
    let!(:expected_pot_hash){ {
      :name => product_pot.name,
      :category => {
        :name => category_cookware.name,
        :subcategories => []
      }
    }}
    let(:serializer){ ::ActiveModel::Serializer::CollectionSerializer.new(collection, :root => root_key, :serializer => ::ProductWithCategorySerializer) }

    it { expect(serialized).to eq(expected_root_key => [expected_tool_hash, expected_pot_hash]) }
  end
end
