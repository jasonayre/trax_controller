module Trax
  module Controller
    module ActionTypes
      extend ::ActiveSupport::Concern
      #todo: pretty janky but works for now

      included do
        class_attribute :action_types

        self.action_types = Hashie::Mash.new({
          :collection => [:index, :search],
          :resource => [ :show, :delete, :update, :create, :login ]
        })
      end

      def current_action
        :"#{request.params["action"]}"
      end

      def collection_action?
        self.class.action_types[:collection].include?(current_action)
      end

      def resource_action?
        self.class.action_types[:resource].include? current_action
      end
    end
  end
end
