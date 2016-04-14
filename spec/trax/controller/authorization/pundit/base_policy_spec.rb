require 'spec_helper'

::RSpec.describe ::Trax::Controller::Authorization::Pundit::BasePolicy do
  let(:widget_policy_class) { ::WidgetPolicy }
  let!(:user) {
    ::User.create(
      :can_read_widgets => true,
      :can_update_widgets => true,
      :can_create_widgets => true,
      :can_destroy_widgets => true,
      :is_admin => false
    )
  }
  let!(:widget) { ::Widget.create(:name => "Haterade", :is_read_only => true) }
  subject { WidgetPolicy.new(user, widget) }

  it { expect(subject.show?).to be true }
  it { expect(subject.update?).to be false }
  it { expect(subject.create?).to be true }
  it { expect(subject.destroy?).to be false }
end
