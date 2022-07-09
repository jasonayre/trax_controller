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
    autoload :Authorize
    autoload :Authorization
    autoload :Config
    autoload :Collection
    autoload :Engine
    autoload :Resource
    autoload :InheritResources
    autoload :ActionTypes
    autoload :PermitParamsFor
    autoload :Serialization

    @configuration ||= ::Trax::Controller::Config.new

    def self.configure(&block)
      block.call(config)
    end

    include ::Trax::Controller::InheritResources
    include ::Trax::Controller::Collection::Base
    include ::Trax::Controller::Resource::Base
    include ::Trax::Controller::Actions
    include ::Trax::Controller::ActionTypes

    class << self
      attr_accessor :configuration
      alias_method :config, :configuration
    end
  end
end

::Trax::Controller::Engine if defined?(::Rails)
