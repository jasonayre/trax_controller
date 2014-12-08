module Trax
  module Controller
    module Collection
      module ResponseMeta
        extend ::ActiveSupport::Concern

        included do
          helper_method :collection_response_meta
        end

        def collection_response_meta
          @collection_response_meta ||= {
            :json_root => collection_root
          }
        end
      end
    end
  end
end
