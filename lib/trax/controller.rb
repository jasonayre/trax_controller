require 'hashie/dash'
require 'hashie/mash'
require 'trax_core'
require 'inherited_resources'
require 'will_paginate'
require 'active_model_serializers'
require 'has_scope'

module Trax
  module Controller
    extend ::ActiveSupport::Concern
    extend ::ActiveSupport::Autoload

    included do
      inherit_resources
    end

    autoload :Actions
    autoload :Collection
    autoload :Resource
    autoload :InheritResources
    autoload :ActionTypes
    autoload :Railtie
    autoload :Serialization

    include ::Trax::Controller::InheritResources
    include ::Trax::Controller::Collection::Base
    include ::Trax::Controller::Resource::Base
    include ::Trax::Controller::Actions
    include ::Trax::Controller::ActionTypes
  end
end

::Trax::Controller::Railtie if defined?(::Rails)
