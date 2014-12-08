module Trax
  module Controller
    module Actions
      extend ::ActiveSupport::Concern

      included do
        respond_to :json
      end

      def index
        render :json => collection,
        :meta => collection_response_meta,
        :each_serializer => collection_serializer,
        :root => collection_root
      end

      def create
        create! do |success, failure|
          success.json do
            render_resource(201)
          end

          failure.json do
            render_errors(:unprocessable_entity, *resource.errors.full_messages)
          end
        end
      end

      def update
        update! do |success, failure|
          success.json do
            render_resource
          end

          failure.json do
            render_errors(:unprocessable_entity, *resource.errors.full_messages)
          end
        end
      end

      def destroy
        destroy! do |success, failure|
          success.json do
            render_resource
          end

          failure.json do
            render_errors(:method_not_allowed, *resource_response_meta[:errors])
          end
        end
      end

      def show
        render_resource
      end

      private

      def render_resource(status = :ok)
        render json: resource, serializer: resource_serializer, meta: resource_response_meta, status: status, scope: serialization_scope
      end

      def render_errors(status, *errors)
        errors = errors.map { |str| str.last == "." ? str : str << "." }
        render json: { meta: { errors: errors } }, status: status, serializer: nil
      end

      def collection_serializer
        resource_serializer
      end

      def resource_serializer
        "#{resource_class.name.demodulize}Serializer".constantize
      end

      def collection_root
        controller_name
      end

      def resource_root
        collection_root.singularize
      end

      def serialized_resource
        @serialized_resource ||= resource_serializer.new(resource, scope: serialization_scope)
      end
    end
  end
end
