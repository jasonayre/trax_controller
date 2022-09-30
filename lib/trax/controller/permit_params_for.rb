module Trax
  module Controller
    module PermitParamsFor
      extend ::ActiveSupport::Concern

      # Allows you to permit params by creating a Trax::Core::Types::Struct
      # https://github.com/jasonayre/trax_core/blob/master/lib/trax/core/types/struct.rb
      #  permitted_params_for_action :create do
      #    string :title
      #  end

      included do
        class_attribute :trax_params_permitters
        self.trax_params_permitters = {}
      end

      def params_permitter_for_action
        action = params[:action]
        return self.trax_params_permitters[action.to_sym] if self.trax_params_permitters.key?(action.to_sym)
        return self.trax_params_permitters[:save] if self.trax_params_permitters.key?(:save) && (action == 'create' || action == 'update' || action == 'first_or_create')
        raise StandardError.new("No param permitter defined for action #{action}")
      end

      def build_resource_params
        _params = request.parameters[resource_request_name]
        self.class.trax_params_permitters[action_name.to_sym].new(_params).to_serializable_hash
      end

      def build_resource
        get_resource_ivar || set_resource_ivar(end_of_association_chain.send(method_for_build, resource_params))
      end

      def update_resource(object, attributes)
        object.update(attributes)
      end

      module ClassMethods
        def permitted_params_for_action(action_name, &block)
          _klass = ::Trax::Core::NamedClass.new("#{self.name}::PermittedParamsForAction#{action_name.to_s.classify}", Trax::Core::Types::Struct, &block)
          self.trax_params_permitters[action_name] = _klass
        end

        def permitted_params_for_save(&block)
          _update_klass = ::Trax::Core::NamedClass.new("#{self.name}::PermittedParamsForActionUpdate", Trax::Core::Types::Struct, &block)
          _create_klass = ::Trax::Core::NamedClass.new("#{self.name}::PermittedParamsForActionCreate", Trax::Core::Types::Struct, &block)
          _first_or_create_klass = ::Trax::Core::NamedClass.new("#{self.name}::PermittedParamsForActionFirstOrCreate", Trax::Core::Types::Struct, &block)
          self.trax_params_permitters[:update] = _update_klass
          self.trax_params_permitters[:create] = _create_klass
          self.trax_params_permitters[:first_or_create] = _first_or_create_klass
        end
      end
    end
  end
end
