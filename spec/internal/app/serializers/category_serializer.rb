class CategorySerializer < ::ActiveModel::Serializer
  attributes :name, :slug

  def slug
    object.name.parameterize('-')
  end

  has_many :products, :serializer => ::ProductSerializer
end
