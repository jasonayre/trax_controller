module Trax
  module Controller
    module Collection
      extend ::ActiveSupport::Autoload

      autoload :Base
      autoload :NestedSearchScopes
      autoload :ResponseMeta
      autoload :Searchable
      autoload :Sortable
      autoload :Pageable
    end
  end
end
