module Trax
  module Controller
    module Collection
      module Pageable
        extend ::ActiveSupport::Concern

        PAGINATION_META_METHODS = [
          :current_page,
          :per_page,
          :size,
          :total_pages,
          :total_entries
        ].freeze

        included do
          collection_defaults :page => 1, :per_page => 25
        end

        def pagination_params
          params[:page] ||= self.class.collection_options.page
          params[:per_page] ||= self.class.collection_options.per_page

          @pagination_params ||= { :page => params[:page], :per_page => params[:per_page] }
        end

        def collection
          @collection ||= super.paginate(pagination_params)
        end

        def collection_pagination_meta
          @collection_pagination_meta ||= ::Trax::Controller::Collection::Pageable::PAGINATION_META_METHODS.inject({}) do |h, key|
            h[key] = collection.__send__(key)
            h
          end
        end

        def collection_response_meta
          if collection_action?
            super.merge!(:pagination => collection_pagination_meta)
          else
            super
          end
        end
      end
    end
  end
end
