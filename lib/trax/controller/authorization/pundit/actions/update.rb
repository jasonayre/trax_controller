module Trax
  module Controller
    module Authorization
      module Pundit
        module Actions
          module Update
            extend ::ActiveSupport::Concern

            def update_resource(object, attributes={})
              object.assign_attributes(*attributes)
              authorize(object)
              super(object, attributes)
            end
          end
        end
      end
    end
  end
end
