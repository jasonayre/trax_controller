module Trax
  module Controller
    module Collection
      module Searchable
        extend ::ActiveSupport::Concern

        def search(**options)
          index(**options)
        end

        def collection_response_meta
          super.merge!(:search_scopes => current_scopes)
        end
      end
    end
  end
end
