class ProductsController < ::ApplicationController
  include ::Trax::Controller
  include ::Trax::Controller::Collection::Pageable

  defaults :resource_class => ::Product

  has_scope :by_id

  actions :index, :show, :create, :update, :destroy

  def product_params
    params.require(:product).permit(:name, :category_id)
  end
end
