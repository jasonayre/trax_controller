module Trax
  module Controller
    module Collection
      module Base
        extend ::ActiveSupport::Concern
        
        included do
          class_attribute :collection_options
          self.collection_options = ::ActiveSupport::OrderedOptions.new
        end

        module ClassMethods
          def collection_defaults(options = {})
            collection_options.merge!(options)
          end
        end

        include ::Trax::Controller::Collection::ResponseMeta
      end
    end
  end
end
