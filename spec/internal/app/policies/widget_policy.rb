class WidgetPolicy < Trax::Controller::Authorization::Pundit::BasePolicy
  def initialize(*args)
    super(*args)
  end

  def index?
    true
  end

  def create?
    @result &&= user.can_create_widgets
  end

  def show?
    @result &&= user.can_read_widgets
  end

  def update?
    @result &&= !resource.is_read_only
    @result &&= user.can_update_widgets
  end

  def destroy?
    @result &&= user.can_destroy_widgets
    @result &&= user.is_admin
  end
end
