module Trax
  module Controller
    module InheritResources
      extend ::ActiveSupport::Concern

      included do
        ::InheritedResources::Base.inherit_resources(self)
        initialize_resources_class_accessors!
        create_resources_url_helpers!
      end
    end
  end
end
