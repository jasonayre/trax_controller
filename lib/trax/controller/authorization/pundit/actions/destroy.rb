module Trax
  module Controller
    module Authorization
      module Pundit
        module Actions
          module Destroy
            extend ::ActiveSupport::Concern

            def destroy_resource(object)
              authorize(object)
              super(object)
            end
          end
        end
      end
    end
  end
end
