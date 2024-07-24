# TraxController

Resourceful more standardized controllers. Uses inherited resources. Geared towards api driven apps.

### Standards

More soon.

### Versions
Please use >= 1.0.0 if you are using ruby 3, or 0.1.4 if you are using <= ruby 3.0

``` ruby
class Admin::Api::WidgetsController < ::Admin::Api::BaseController
  include ::Trax::Controller

  defaults :resource_class => ::Widget

  def resource_serializer
    ::Admin::Api::WidgetSerializer
  end

  #normally same as above unless overridden
  def collection_serializer
    ::Admin::Api::WidgetSerializer
  end
end
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'trax_controller'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install trax_controller

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it ( https://github.com/[my-github-username]/trax_controller/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
