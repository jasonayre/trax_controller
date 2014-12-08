module Trax
  module Controller
    module Resource
      extend ::ActiveSupport::Autoload

      autoload :Base
      autoload :Errors
      autoload :ResponseMeta
    end
  end
end
