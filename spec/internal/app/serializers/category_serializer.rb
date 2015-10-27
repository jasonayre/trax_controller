class CategorySerializer < ::ActiveModel::Serializer
  attributes :name, :slug

  def slug
    name.parameterize('-')
  end

  has_many :products, :serializer => ::ProductSerializer
end
