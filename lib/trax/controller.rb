require 'hashie/dash'
require 'hashie/mash'
require 'trax_core'
require 'inherited_resources'
require 'will_paginate'

module Trax
  module Controller
    extend ::ActiveSupport::Concern
    extend ::ActiveSupport::Autoload
    extend ::Trax::Core::HasMixins

    included do
      define_configuration_options!(:trax_controller) do
        #core inherited resources defaults
        option :resource_class
        option :singleton, :default => false
        option :instance_name
        option :collection_name
        option :route_prefix
        option :finder

        option :resource_serializer
        option :collection_serializer
        option :serializer
        option :collection_root, :default => lambda{ |controller|
          controller.controller_name
        }
        option :resource_root

        after_configured do |config|
          inherited_resources_defaults = config.as!(&[
            :resource_class, :singleton, :instance_name, :collection_name, :route_prefix, :finder
          ]).compact!

          unless inherited_resources_defaults.nil? || inherited_resources_defaults.blank?
            config.class.source.__send__(:defaults, inherited_resources_defaults)
          end

          #create delegators on controller for these methods for backwards compat

          config.hash.compact!.keys.select!{ |k|
            [:collection_serializer, :resource_serializer, :collection_root, :resource_root].include?(k)
          }.each do |k,v|
            self.source.define_singleton_method(k) do
              trax_controller_config.__send__(k)
            end
          end
        end

        klass do
          def resource_serializer=(val)
            val = val.is_a?(String) ? val.constantize : val

            super(val)
          end

          def collection_serializer=(val)
            val = val.is_a?(String) ? val.constantize : val
            super(val)
          end

          def serializer=(val)
            self.resource_serializer = val
            self.collection_serializer = val
            super(val)
          end
        end
      end

      inherit_resources
    end

    autoload :Actions
    autoload :Collection
    autoload :Resource
    autoload :InheritResources
    autoload :ActionTypes

    include ::Trax::Controller::InheritResources
    include ::Trax::Controller::Collection::Base
    include ::Trax::Controller::Resource::Base
    include ::Trax::Controller::Actions
    include ::Trax::Controller::ActionTypes
  end
end
