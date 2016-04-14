module Trax
  module Controller
    module Authorization
      module Pundit
        module Actions
          module Index
            extend ::ActiveSupport::Concern

            def index(*args, **options)
              authorize(collection)
              super(*args, **options)
            end
          end
        end
      end
    end
  end
end
