module Trax
  module Controller
    module Collection
      module Searchable
        extend ::ActiveSupport::Concern

        def search
          render :json => search_collection,
                 :meta => collection_response_meta,
                 :each_serializer => collection_serializer,
                 :root => collection_root
        end

        def search_collection
          @search_collection ||= begin
            search_keys = self.class.scopes_configuration.keys

            search_keys.inject(collection.all) do |result, key|
              relation = params.has_key?("#{key}") ? result.__send__(key, params[key]) : result
              relation
            end.all
          end
        end

        def collection_searchable_meta
          @collection_pagination_meta ||= ::Trax::Controller::Collection::Pageable::PAGINATION_META_METHODS.inject({}) do |h, key|
            h[key] = collection.__send__(key)
            h
          end
        end

        def collection_response_meta
          if collection_action?
            super.merge!(:search_scopes => current_scopes)
          else
            super
          end
        end
      end
    end
  end
end
