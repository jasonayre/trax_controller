# This adapter is a workaround for
# https://github.com/rails-api/active_model_serializers/issues/835 until
# https://github.com/rails-api/active_model_serializers/pull/952 is merged

module Trax
  module Controller
    module Serialization
      module Adapters
        class Json < ActiveModel::Serializer::Adapter::Json
          def serializable_hash(options={})
            is_collection? ? collection_serializable_hash(options) : resource_serializable_hash(options)
          end

          private

          def collection_result
            @collection_result ||= []
          end

          def collection_serializable_hash(options={})
            _result = collection_result + serializer.map { |s| FlattenJson.new(s).serializable_hash(options) }
            { root =>  _result }
          end

          def is_collection?
            serializer.respond_to?(:each)
          end

          def resource_result
            @resource_result ||= {}
          end

          def resource_serializable_hash(options={})
            cache_check(serializer){ resource_result.merge!(serializer.attributes(options)) }
            serialize_resource_associations
            { root => resource_result }
          end

          def serialize_resource_associations
            serializer.associations.each do |association|
              association_serializer = association.serializer
              association_options = association.options

              if association_serializer.respond_to?(:each)
                array_serializer = association_serializer

                resource_result[association.key] = array_serializer.map do |item|
                  cache_check(item) { FlattenJson.new(item).serializable_hash }
                end
              else
                resource_result[association.key] = if association_serializer && association_serializer.object
                  cache_check(association_serializer) { FlattenJson.new(association_serializer).serializable_hash }
                elsif association_options[:virtual_value]
                  association_options[:virtual_value]
                end
              end
            end
          end
        end
      end
    end
  end
end
