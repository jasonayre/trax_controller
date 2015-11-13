# This adapter is a workaround for
# https://github.com/rails-api/active_model_serializers/issues/835 until
# https://github.com/rails-api/active_model_serializers/pull/952 is merged

module Trax
  module Controller
    module Serialization
      module Adapters
        class Json < ActiveModel::Serializer::Adapter::Json
          def serializable_hash(options={})
            result = is_collection? ? collection_serializable_hash(options) : resource_serializable_hash(options)
            @options[:nested] ? result : { root =>  result }
          end

          private

          def collection_serializable_hash(options={})
            serializer.map { |s| FlattenJson.new(s).serializable_hash(options) }
          end

          def is_collection?
            serializer.respond_to?(:each)
          end

          def resource_serializable_hash(options={})
            cached = cache_check(serializer){ serializer.attributes(options) }
            resource_result = serialize_resource_associations
            cached.merge(resource_result)
          end

          def serialize_resource_associations
            resource_result = {}

            serializer.associations.each do |association|
              association_serializer = association.serializer
              association_options = association.options

              if association_serializer.respond_to?(:each)
                array_serializer = association_serializer

                resource_result[association.key] = array_serializer.map do |item|
                  cache_check(item) { self.class.new(item, :nested => true).serializable_hash }
                end
              else
                resource_result[association.key] = if association_serializer && association_serializer.object
                  cache_check(association_serializer) { self.class.new(association_serializer, :nested => true).serializable_hash }
                elsif association_options[:virtual_value]
                  association_options[:virtual_value]
                end
              end
            end

            resource_result
          end
        end
      end
    end
  end
end
