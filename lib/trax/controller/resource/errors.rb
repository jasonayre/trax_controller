module Trax
  module Controller
    module Resource
      module Errors
        extend ::ActiveSupport::Concern

        def resource_errors?
          resource.errors.any?
        end

        def resource_response_meta
          if resource_action? && resource_errors?
            super.merge!(:errors => resource.errors.messages)
          else
            super
          end
        end
      end
    end
  end
end
