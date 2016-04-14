require 'spec_helper'

::RSpec.describe ::Trax::Controller::Authorization::Pundit do
  before(:all) do
    ::Trax::Controller.config.authorization_adapter = ::Trax::Controller::Authorization::Pundit::Adapter
  end

  context "WidgetsController" do
    context "Unit Test" do
      subject { ::WidgetsController }

      context ".actions_to_authorize" do
        it "includes the pundit actions for each action being authorized" do
          expect(subject.ancestors).to include(Trax::Controller::Authorization::Pundit::Actions::Update)
        end
      end
    end

    context "Integration Test", :type => :controller do

    end
  end
end
