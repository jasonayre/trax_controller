require 'rubygems'
require 'bundler'
require 'combustion'
require 'pry'
require 'active_record'

::Combustion.schema_format = :ruby
::Combustion.initialize! :all

require 'rspec/rails'
require 'simplecov'
require 'pry'
require 'trax_controller'

::SimpleCov.start do
  add_filter '/spec/'
end

::RSpec.configure do |config|
  config.include RSpec::Rails::RequestExampleGroup, type: :feature

  config.before(:all) do
    ::Trax::Controller.config.authorization_adapter = ::Trax::Controller::Authorization::Pundit::Adapter
  end
end

::Bundler.require(:default, :development, :test)

::Dir["#{::File.dirname(__FILE__)}/support/*.rb"].each {|f| require f }
