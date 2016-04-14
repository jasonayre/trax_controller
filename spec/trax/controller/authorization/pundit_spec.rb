require 'spec_helper'

::RSpec.describe ::Trax::Controller::Authorization::Pundit do
  before(:all) do
    ::Trax::Controller.config.authorization_adapter = ::Trax::Controller::Authorization::Pundit::Adapter

    ::WidgetsController.class_eval do
      include ::Trax::Controller::Authorize
      actions_to_authorize :index, :show, :create, :update, :destroy
      policy_class ::WidgetPolicy
    end
  end

  context "WidgetsController" do
    context "Unit Test" do
      subject { ::WidgetsController }

      context ".actions_to_authorize" do
        {
          :index => Trax::Controller::Authorization::Pundit::Actions::Index,
          :create => Trax::Controller::Authorization::Pundit::Actions::Create,
          :show => Trax::Controller::Authorization::Pundit::Actions::Show,
          :destroy => Trax::Controller::Authorization::Pundit::Actions::Destroy,
          :update => Trax::Controller::Authorization::Pundit::Actions::Update
        }.each_pair do |k,v|
          it "includes the pundit action for #{k}" do
            expect(subject.ancestors).to include(v)
          end
        end
      end
    end

    describe WidgetsController, :type => :controller do
      let!(:user) {
        ::User.create(
          :email => 'kanyewest@theleatherjoggingpants.com',
          :can_read_widgets => true,
          :can_update_widgets => true,
          :can_create_widgets => true,
          :can_destroy_widgets => true,
          :is_admin => false
        )
      }

      let!(:widget) { ::Widget.create(:name => "Water Bottle", :is_read_only => true, :quantity => 5) }

      describe '#show' do
        it 'user can accesss' do
          get :show, id: widget.id
          expect(response).to be_ok
          json = JSON.parse response.body
          expect(json).to have_key('widget')
        end
      end

      describe '#update' do
        context "user cannot update" do
          let(:updated_widget_name) { 'Kanyes water bottle' }
          let(:params){ {
            :format => :json,
            :id => widget.id,
            :widget => widget_params
          }}
          let(:widget_params) { { :name => updated_widget_name } }

          before { put :update, params }

          it { expect(response).to_not be_successful }
          it {
            json = JSON.parse response.body
            expect(json).to have_key("meta")
            expect(json["meta"]).to have_key("errors")
            expect(json["meta"]["errors"]).to have_key("not_authorized")
          }
          it { expect(response.status).to eq 403 }
        end
      end
    end
  end
end
