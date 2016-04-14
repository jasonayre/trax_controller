module Trax
  module Controller
    module Authorization
      module Pundit
        module Actions
          extend ::ActiveSupport::Autoload

          autoload :Create
          autoload :Destroy
          autoload :Index
          autoload :New
          autoload :Search
          autoload :Show
          autoload :Update
        end
      end
    end
  end
end
