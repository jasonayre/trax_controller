class CategoriesController < ::ApplicationController
  include ::Trax::Controller
  include ::Trax::Controller::Collection::Pageable

  defaults :resource_class => ::Category

  has_scope :by_id

  actions :index, :show, :create, :update, :destroy

  def category_params
    params.require(:category).permit(:name)
  end

  def resource_serializer
    ::CategorySerializer
  end

  def collection_serializer
    ::CategoriesSerializer
  end
end
