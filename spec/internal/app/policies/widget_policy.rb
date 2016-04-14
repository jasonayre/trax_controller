class WidgetPolicy < Trax::Controller::Authorization::Pundit::BasePolicy
  def initialize(*args)
    super(*args)
  end

  def index?
    true
  end

  def show?
    true
  end

  def update?
    true
  end
end
