module Trax
  module Controller
    module Actions
      extend ::ActiveSupport::Concern

      included do
        respond_to :json
      end

      def index(collection: _collection, meta: collection_response_meta, serializer: collection_serializer, root: collection_root)
        render :json => collection,
               :meta => meta,
               :each_serializer => serializer,
               :root => root
      end

      #setting resource ivar stops it from trying to create via the default behavior
      def create(success_status:201, failure_status: :unprocessable_entity, **options)
        set_resource_ivar(options[:resource]) if options.has_key?(:resource)

        create! do |success, failure|
          success.json do
            render_resource(success_status, **options)
          end

          failure.json do
            render_errors(failure_status, **options)
          end
        end
      end

      def update(success_status:200, failure_status: :unprocessable_entity, **options)
        set_resource_ivar(options[:resource]) if options.has_key?(:resource)

        update! do |success, failure|
          success.json do
            render_resource(success_status, **options)
          end

          failure.json do
            render_errors(failure_status, **options)
          end
        end
      end

      def destroy(success_status:200, failure_status: :method_not_allowed, **options)
        set_resource_ivar(options[:resource]) if options.has_key?(:resource)

        destroy! do |success, failure|
          success.json do
            render_resource(success_status, **options)
          end

          failure.json do
            render_errors(failure_status, **options)
          end
        end
      end

      def show(*args, **options)
        render_resource(*args, **options)
      end

      private

      def collection_serializer
        resource_serializer
      end

      def collection_root
        controller_name
      end

      #this is to avoid circular reference argument that we would otherwise get with render_resource
      def _collection
        collection
      end

      def _resource
        resource
      end

      def resource_serializer
        "#{resource_class.name.demodulize}Serializer".constantize
      end

      def resource_root
        collection_root.singularize
      end

      #this overwrite allows a separate set of params to be used for create/update
      #i.e. product_params_for_create, product_params_for_update
      def resource_params_method_name
        if respond_to?("#{resource_instance_name}_params_for_#{params[:action]}", true)
          "#{resource_instance_name}_params_for_#{params[:action]}"
        else
          super
        end
      end

      #will set the resource instance var to whatever you pass it, then render
      def render_resource!(object, **options)
        instance_variable_set(:"@#{self.class.resources_configuration[:self][:instance_name]}", object)
        render_resource(**options)
      end

      def render_resource(status = :ok, resource: _resource, serializer: resource_serializer, meta: resource_response_meta, scope: serialization_scope, root: resource_root)
        render json: resource, serializer: serializer, meta: meta, status: status, scope: scope, root: root
      end

      def render_errors(status = :unprocessable_entity, error_messages_hash:{}, **options)
        errors = if resource_action?
          error_messages_hash.merge(resource_error_messages(**options) || {})
        else
          error_messages_hash.merge({})
        end

        render json: { meta: { errors: errors } }, status: status, serializer: nil
      end

      def resource_error_messages(resource: _resource, **options)
        return nil unless resource.errors.any?

        resource.errors.inject({}) do |result, error|
          field = "#{error[0]}"
          message = error[1]
          result[field] = message.downcase.include?(field) ? message : "#{field.titleize} #{message}"
          result
        end
      end

      #this metthod is in limbo because it appears this was removed from master branch of AMS?
      def serialized_resource
        @serialized_resource ||= resource_serializer.new(resource, scope: serialization_scope)
      end
    end
  end
end
