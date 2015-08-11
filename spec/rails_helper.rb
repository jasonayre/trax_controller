ENV['RAILS_ENV'] ||= 'test'
require 'spec_helper'
require 'rspec/rails'
require "active_model"
require "active_model_serializers"
require "action_controller/railtie"

class ApplicationController < ActionController::Base; end

module Test
  class Application < Rails::Application
    config.eager_load = false
    config.action_controller.perform_caching = false
    config.action_controller.allow_forgery_protection = false
    config.action_dispatch.show_exceptions = false
    config.active_support.test_order = :random
    config.active_support.deprecation = :stderr
    config.secret_key_base = '24618ac1367ab45ab87f51a237f0594026e52dcd30fa2dc1846ab0ca7bfcda2f8274829746dea3b057ea25af097a9cbaf98327541aceaedb8672d41158617558'
  end

  class Model
    include ActiveModel::Model

    class << self
      def all
        [ self.new(id: 5),
          self.new(id: 7),
          self.new(id: 11)
        ]
      end
    end

    attr_accessor :id

    def read_attribute_for_serialization(name)
      send name
    end
  end

  class ModelSerializer < ActiveModel::Serializer
    attributes :id
  end
end

Rails.application.initialize!
