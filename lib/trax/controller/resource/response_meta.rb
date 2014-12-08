module Trax
  module Controller
    module Resource
      module ResponseMeta
        extend ::ActiveSupport::Concern

        included do
          helper_method :resource_response_meta
        end

        def resource_response_meta
          @resource_response_meta ||= {
            :json_root => resource_root
          }
        end
      end
    end
  end
end
