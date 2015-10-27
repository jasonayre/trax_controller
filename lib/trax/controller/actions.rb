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

      def create
        create! do |success, failure|
          success.json do
            render_resource(201)
          end

          failure.json do
            render_errors(:unprocessable_entity, resource_error_messages)
          end
        end
      end

      def update
        update! do |success, failure|
          success.json do
            render_resource
          end

          failure.json do
            render_errors(:unprocessable_entity, resource_error_messages)
          end
        end
      end

      def destroy
        destroy! do |success, failure|
          success.json do
            render_resource
          end

          failure.json do
            render_errors(:method_not_allowed, resource_response_meta[:errors])
          end
        end
      end

      def show
        render_resource
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

      #will set the resource instance var to whatever you pass it, then render
      def render_resource!(object, **options)
        instance_variable_set(:"@#{self.class.resources_configuration[:self][:instance_name]}", object)
        render_resource(**options)
      end

      def render_resource(status = :ok, resource: _resource, serializer: resource_serializer, meta: resource_response_meta, scope: serialization_scope, root: resource_root)
        render json: _resource, serializer: serializer, meta: meta, status: status, scope: scope, :root => root
      end

      def render_errors(status, error_messages_hash)
        render json: { meta: { errors: error_messages_hash } }, status: status, serializer: nil
      end

      def resource_error_messages(resource: current_resource)
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
