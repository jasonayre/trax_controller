module Trax
  module Controller
    module Authorization
      module Pundit
        module Actions
          module New
            extend ::ActiveSupport::Concern

            def new(*args, *options)
              authorize(build_resource)
              super(*args, *options)
            end
          end
        end
      end
    end
  end
end
