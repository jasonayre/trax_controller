require 'spec_helper'

class NameCategorySerializer < ::ActiveModel::Serializer
  attributes :name
  has_many :subcategories, :serializer => NameCategorySerializer
end

class NameProductSerializer < ::ActiveModel::Serializer
  attributes :name
  has_one :category, :serializer => NameCategorySerializer
end

describe Trax::Controller::Serialization::Adapters::Json do
  let(:category_flat_heads){ ::Category.new(:name => "flat heads") }
  let(:category_screwdrivers){ ::Category.new(:name => "screwdrivers", :subcategories => [category_flat_heads]) }
  let(:category_knives){ ::Category.new(:name => "knives") }
  let(:category_tools){ ::Category.new(:name => "tools", :subcategories => [category_screwdrivers, category_knives]) }
  let(:product){ ::Product.new(:name => "Generics Multi-Purpose Tool", :category => category_tools) }
  let(:serializer){ ::NameProductSerializer.new(product) }
  subject(:serialized){ described_class.new(serializer).serializable_hash }

  it {
    expected = { :product => {
      :name => product.name,
      :category => {
        :name => category_tools.name,
        :subcategories => [
          { :name => category_screwdrivers.name,
            :subcategories => [{:name => category_flat_heads.name}]
          },
          {:name => category_knives.name}
        ]
      }
    }}
    expect(serialized).to eq expected
  }
end
