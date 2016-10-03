class CategoryWithSubcategorySerializer < ::ActiveModel::Serializer
  attributes :name
  has_many :subcategories, :serializer => CategoryWithSubcategorySerializer
end
