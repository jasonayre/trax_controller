module Trax
  module Controller
    module Authorize
      extend ::ActiveSupport::Concern
      include ::Trax::Controller.config.authorization_adapter

      STANDARD_ACTIONS = [ :index, :search, :show, :destroy, :update, :create, :new ]

      module ClassMethods
        def actions_to_authorize(*_actions, all:false, except:false, only:false)
          _actions += (all || except) ? STANDARD_ACTIONS.dup : []
          _actions += only if only
          _actions.reject!{ |_action| except.include?(_action) } if except

          _actions.each do |action|
            action_module = ::Trax::Controller.config.authorization_adapter.authorization_action_for(action)
            include action_module if action_module
          end
        end
      end
    end
  end
end
