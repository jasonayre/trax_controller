module Trax
  module Controller
    module Collection
      extend ::ActiveSupport::Autoload

      autoload :Base
      autoload :ResponseMeta
      autoload :Searchable
      autoload :Pageable
    end
  end
end
