module Trax
  module Controller
    module ActionTypes
      extend ::ActiveSupport::Concern

      def current_action
        :"#{request.params["action"]}"
      end

      def collection_action?
        !!get_collection_ivar
      end

      def resource_action?
        !!get_resource_ivar
      end
    end
  end
end
