module Trax
  module Controller
    module Authorization
      module Pundit
        extend ::ActiveSupport::Autoload

        autoload :Actions
        autoload :Adapter
        autoload :BasePolicy
      end
    end
  end
end
