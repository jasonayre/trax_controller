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
      let!(:user1) {
        ::User.create(
          :email => 'kanyewest@theleatherjoggingpants.com',
          :can_read_widgets => true,
          :can_update_widgets => true,
          :can_create_widgets => true,
          :can_destroy_widgets => true,
          :is_admin => false
        )
      }

      let!(:user2) {
        ::User.create(
          :email => 'kanyewest@waterbottledesign.com',
          :can_read_widgets => false,
          :can_update_widgets => true,
          :can_create_widgets => false,
          :can_destroy_widgets => false,
          :is_admin => true
        )
      }

      let(:user_who_can) {
        {
          :read_widgets => user1,
          :update_widgets => user2,
          :create_widgets => user1,
          :destroy_widgets => user1
        }
      }

      let(:user_who_cannot) {
        {
          :read_widgets => user2,
          :update_widgets => user1,
          :create_widgets => user2,
          :destroy_widgets => user2
        }
      }

      let(:common_params) { {:user_email => current_user.email} }
      let!(:widget) { ::Widget.create(:name => "Water Bottle", :is_read_only => true, :quantity => 5) }

      let(:unauthorized_result_expectations) {
        lambda { |json|
          expect(json).to have_key("meta")
          expect(json["meta"]).to have_key("errors")
          expect(json["meta"]["errors"]).to have_key("not_authorized")
        }
      }

      describe '#show' do
        context 'user can read widgets' do
          let(:current_user) { user_who_can[:read_widgets] }

          it 'is authorized' do
            get :show, common_params.merge!(id: widget.id)
            expect(response).to be_ok
            json = JSON.parse response.body
            expect(json).to have_key('widget')
          end
        end

        context 'user cannot read widgets' do
          let(:current_user) { user_who_cannot[:read_widgets] }

          it do
            get :show, common_params.merge!(id: widget.id)
            expect(response).to_not be_ok
            json = JSON.parse response.body
            unauthorized_result_expectations.call(json)
          end
        end
      end

      describe '#create' do
        context "user can create widgets" do
          let(:current_user) { user_who_can[:create_widgets] }
          let(:widget_name) { 'Kanyes water bottle' }
          let(:params){ {
            :format => :json,
            :widget => widget_params
          }}
          let(:widget_params) { { :name => 'Marble Conference Table', :quantity => 1 } }
          before { post :create, common_params.merge(params) }

          it { expect(response).to be_successful }
        end

        context "user cannot create widgets" do
          let(:current_user) { user_who_cannot[:create_widgets] }
          let(:params){ {
            :format => :json,
            :widget => widget_params
          }}
          let(:widget_params) { { :name => 'Marble Conference Table', :quantity => 1  } }
          before { post :create, common_params.merge(params) }

          it {
            expect(response).to_not be_ok
            json = JSON.parse response.body
            unauthorized_result_expectations.call(json)
          }
        end
      end

      describe '#update' do
        context "user cannot update widgets" do
          let(:current_user) { user_who_cannot[:update_widgets] }
          let(:updated_widget_name) { 'Kanyes water bottle' }
          let(:params){ {
            :format => :json,
            :id => widget.id,
            :widget => widget_params
          }}
          let(:widget_params) { { :name => updated_widget_name, :quantity => 1  } }

          before { put :update, common_params.merge(params) }

          it { expect(response).to_not be_successful }
          it { expect(response.status).to eq 403 }
          it {
            expect(response).to_not be_ok
            json = JSON.parse response.body
            unauthorized_result_expectations.call(json)
          }
        end

        context "user can update widgets", :focus => true do
          let(:current_user) { user_who_can[:update_widgets] }
          let(:updated_widget_name) { 'Kanyes water bottle' }
          let(:params){ {
            :format => :json,
            :id => widget.id,
            :widget => widget_params
          }}
          let(:widget_params) { { :name => updated_widget_name, :quantity => 1  } }
          let(:request_params) { common_params.merge(params) }

          before { put :update, request_params }

          it { expect(response).to_not be_successful }
          it { expect(response.status).to eq 403 }
          it {

            expect(response).to be_ok
          }
        end
      end
    end
  end
end
