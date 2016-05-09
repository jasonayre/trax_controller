module Trax
  module Controller
    module Collection
      module Sortable
        extend ::ActiveSupport::Concern

        SORT_DIRECTIONS = [ "asc", "desc" ].freeze

        module ClassMethods
          def has_sort_scope(sort_scope_name, only: [:index, :search], type: :boolean, **options)
            SORT_DIRECTIONS.each do |dir|
              _sort_scope_name = :"#{sort_scope_name}_#{dir}"

              puts _sort_scope_name

              has_scope(_sort_scope_name, only: only, type: type, **options)
            end
          end

          def has_sort_scopes(*names, **options)
            names.each{ |_name| has_sort_scope(_name, **options) }
          end
        end
      end
    end
  end
end
