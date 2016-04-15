module Trax
  module Controller
    module Authorization
      module Pundit
        module Actions
          module Read
            extend ::ActiveSupport::Concern

            include ::Trax::Controller::Authorization::Pundit::Actions::Index
            include ::Trax::Controller::Authorization::Pundit::Actions::Show
            include ::Trax::Controller::Authorization::Pundit::Actions::Search
          end
        end
      end
    end
  end
