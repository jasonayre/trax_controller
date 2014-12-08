require 'hashie/dash'
require 'hashie/mash'
require 'trax_core'
require 'inherited_resources'

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

    include ::Trax::Controller::InheritResources
    include ::Trax::Controller::Collection::Base
    include ::Trax::Controller::Resource::Base
    include ::Trax::Controller::Actions

    # inherit_resources



    # included do
    #   inherit_resources
    # end


  end
end
