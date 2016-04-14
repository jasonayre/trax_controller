module Trax
  module Controller
    module Authorization
      module Pundit
        class BasePolicy
          attr_accessor :user, :resource, :result

          #Result is set to true by default because it makes chaining easy with &&=
          def initialize(user, resource)
            @user = user
            @resource = resource
            @result = true
          end
        end
      end
    end
  end
end
