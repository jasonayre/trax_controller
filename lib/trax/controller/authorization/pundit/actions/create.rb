module Trax
  module Controller
    module Authorization
      module Pundit
        module Actions
          module Create
            extend ::ActiveSupport::Concern

            def create_resource(object)
              authorize(object)
              super(object)
            end
          end
        end
      end
    end
  end
end
