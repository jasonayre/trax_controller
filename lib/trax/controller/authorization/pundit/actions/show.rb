module Trax
  module Controller
    module Authorization
      module Pundit
        module Actions
          module Show
            extend ::ActiveSupport::Concern

            def show(*args, **options)
              authorize(resource)
              super(*args, **options)
            end
          end
        end
      end
    end
  end
end
