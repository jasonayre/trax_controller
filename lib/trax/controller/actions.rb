module Trax
  module Controller
    module Actions
      extend ::ActiveSupport::Concern

      included do
        respond_to :json
      end

      def index
        render_collection(collection)
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

      def resource_serializer
        "#{resource_class.name.demodulize}Serializer".constantize
      end

      def resource_root
        collection_root.singularize
      end

      def render_collection(objects)
        render :json => objects,
               :meta => collection_response_meta,
               :each_serializer => collection_serializer,
               :root => collection_root
      end

      #will set the resource instance var to whatever you pass it, then render
      def render_resource!(object)
        instance_variable_set(:"@#{self.class.resources_configuration[:self][:instance_name]}", object)
        render_resource
      end

      def render_resource(status = :ok)
        render json: resource, serializer: resource_serializer, meta: resource_response_meta, status: status, scope: serialization_scope, :root => resource_root
      end

      def render_errors(status, error_messages_hash)
        render json: { meta: { errors: error_messages_hash } }, status: status, serializer: nil
      end

      def resource_error_messages
        @resource_error_messages ||= begin
          return nil unless resource.errors.any?

          resource.errors.inject({}) do |result, error|
            field = "#{error[0]}"
            message = error[1]
            result[field] = message.downcase.include?(field) ? message : "#{field.titleize} #{message}"
            result
          end
        end
      end

      def serialized_resource
        @serialized_resource ||= resource_serializer.new(resource, scope: serialization_scope)
      end
    end
  end
end
