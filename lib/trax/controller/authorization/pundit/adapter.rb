module Trax
  module Controller
    module Authorization
      module Pundit
        module Adapter
          extend ::ActiveSupport::Concern

          included do
            rescue_from ::Pundit::NotAuthorizedError, :with => :render_pundit_errors
            class_attribute :_policy_class
          end

          def render_pundit_errors
            render_errors(:forbidden, error_messages_hash: { :not_authorized => 'You are not authorized to perform this action' } )
          end

          def policy(record)
            self.class._policy_class.new(current_user, record)
          end

          def self.authorization_action_for(action_name)
            "::Trax::Controller::Authorization::Pundit::Actions::#{action_name.to_s.camelize}".safe_constantize
          end

          module ClassMethods
            def policy_class(klass)
              self._policy_class = klass
            end

            def policy!(user, record)
              _policy_class.new(user, record)
            end
          end
        end
      end
    end
  end
end
