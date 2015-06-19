require 'rubygems'


require 'bundler/setup'

require 'combustion'


Combustion.initialize! :all

require 'simplecov'
require 'pry'
require 'trax_controller'

RSpec.configure do |config|

end
# require_relative './support/controllers'

SimpleCov.start do
  add_filter '/spec/'
end


Bundler.require(:default, :development, :test)

::Dir["#{::File.dirname(__FILE__)}/support/*.rb"].each {|f| require f }
