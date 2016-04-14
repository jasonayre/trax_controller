require 'active_support/ordered_options'

module Trax
  module Controller
    class Config < ::ActiveSupport::InheritableOptions
      def initialize(*args)
        super(*args)

        self[:authorization_adapter] = false
      end
    end
  end
end
