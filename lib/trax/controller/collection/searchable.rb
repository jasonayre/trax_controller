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
      end
    end
  end
end
