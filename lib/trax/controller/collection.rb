module Trax
  module Controller
    module Collection
      extend ::ActiveSupport::Autoload

      autoload :Base
      autoload :ResponseMeta
      autoload :Searchable
    end
  end
end
