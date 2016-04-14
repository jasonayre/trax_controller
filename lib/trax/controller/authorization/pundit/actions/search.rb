module Trax
  module Controller
    module Authorization
      module Pundit
        module Actions
          module Search
            extend ::ActiveSupport::Concern

            def search(*args, **options)
              authorize(collection)
              super(*args, **options)
            end
          end
        end
      end
    end
  end
end
