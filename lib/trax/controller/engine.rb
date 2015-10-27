module Trax
  module Controller
    class Engine < ::Rails::Engine
      initializer 'trax_controller.active_model_serializers' do |app|
        ::ActiveModel::Serializer.config.adapter = Trax::Controller::Serialization::Adapters::Json
      end
    end
  end
end
