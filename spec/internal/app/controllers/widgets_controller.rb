class WidgetsController < ::ApplicationController
  include ::Trax::Controller
  include ::Trax::Controller::Collection::Pageable

  defaults :resource_class => ::Widget

  has_scope :by_id

  actions :index, :show, :create, :update, :destroy

  def widget_params
    params.require(:widget).permit(:name, :quantity)
  end

  def user_email
    params[:user_email]
  end

  def current_user
    @current_user ||= ::User.find_by(:email => user_email)
    binding.pry
  end
end
