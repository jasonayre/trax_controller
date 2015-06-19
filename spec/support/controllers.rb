require 'rails'

class PostsSerializer < SimpleDelegator
  def initialize(obj)
    @obj = obj
  end

  def __getobj__
    @obj
  end

end

class ApplicationController < ::ActionController::Base

end

class PostsController < ::ApplicationController
  include ::Trax::Controller

  configure_trax_controller do |options|
    options.serializer = ::PostsSerializer
    # serializer = ::PostsSerializer
    # options.serializer = ::PostsSerializer
  end
end
