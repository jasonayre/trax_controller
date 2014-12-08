module Trax
  module Controller
    module Resource
      module Base
        extend ::ActiveSupport::Concern

        included do
          class_attribute :resource_options
        end

        include ::Trax::Controller::Resource::ResponseMeta
        include ::Trax::Controller::Resource::Errors
      end
    end
  end
end
