class CategoriesController < ::ApplicationController
  include ::Trax::Controller
  include ::Trax::Controller::Collection::Pageable

  defaults :resource_class => ::Category

  has_scope :by_id

  actions :index, :show, :create, :update, :destroy

  def create_with_modified_response_codes
    create(success_status: :accepted, failure_status: 404)
  end

  def create_with_modified_resource
    @widget = Widget.create(widget_params)
    create(resource: @widget, root: 'widget', serializer: WidgetSerializer)
  end

  def show_without_products
    render_resource(serializer: ::CategoriesSerializer)
  end

  def widget
    render_resource(serializer: ::CategoriesSerializer, resource: Widget.new(:name => 'whatever'))
  end

  def widget_with_renamed_root
    render_resource(serializer: ::CategoriesSerializer, root: 'widget', resource: Widget.new(:name => 'whatever'))
  end

  def show_by_calling_original_action
    show(serializer: ::CategoriesSerializer, root: 'show_by_calling_original_action')
  end

  def product_with_category
    render_resource(serializer: ::ProductWithCategorySerializer, root: 'product', resource: Product.find(params[:id]))
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end

  def widget_params
    params.require(:widget).permit(:name, :quantity)
  end

  def resource_serializer
    ::CategorySerializer
  end

  def collection_serializer
    ::CategoriesSerializer
  end
end
