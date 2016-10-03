module Trax
  module Controller
    module Serialization
      module Adapters
        class Json < ::ActiveModelSerializers::Adapter::Json
          def initialize(serializer, options = {})
            super
            options[:include] = '**'
          end
        end
      end
    end
  end
end
