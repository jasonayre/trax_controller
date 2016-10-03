require "category_with_subcategories_serializer"

class ProductWithCategorySerializer < ::ActiveModel::Serializer
  attributes :name
  has_one :category, :serializer => CategoryWithSubcategorySerializer
end
