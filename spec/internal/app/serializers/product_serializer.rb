class ProductSerializer < ::ActiveModel::Serializer
  attributes :id, :name, :quantity, :category_id
end
