module Trax
  module Controller
    module Collection
      module NestedSearchScopes
        extend ::ActiveSupport::Concern

        module ClassMethods
          def has_nested_scopes_for(scope_name, as:, model:, permitted_scopes: [], only: [:index, :search], type: :hash, **options)
            has_scope(scope_name, as: as, only: only, type: type, **options) do |controller, scope, value|
              scope_ivar_name = "@#{scope_name}_scope"
              instance_variable_set(:"#{scope_ivar_name}", model)

              value.each_pair do |k,v|
                raise ::ActionController::ParameterMissing.new("Invalid search parameter #{k} #{v}") unless permitted_scopes.include?(k)

                instance_variable_set(
                  :"#{scope_ivar_name}",
                  instance_variable_get(:"#{scope_ivar_name}").all.__send__(k, v)
                )
              end

              scope.__send__(scope_name, instance_variable_get(:"#{scope_ivar_name}"))
            end
          end
        end
      end
    end
  end
end
