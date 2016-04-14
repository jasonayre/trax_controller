class WidgetsController < ::ApplicationController
  include ::Trax::Controller
  include ::Trax::Controller::Collection::Pageable
  include ::Trax::Controller::Authorize

  defaults :resource_class => ::Widget

  has_scope :by_id

  actions :index, :show, :create, :update, :destroy
  actions_to_authorize :index, :show, :create, :update, :destroy
  policy_class ::WidgetPolicy

  def widget_params
    params.require(:widget).permit(:name, :quantity)
  end

  def current_user
    @current_user ||= ::User.first
  end
end
