# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'trax_controller/version'

Gem::Specification.new do |spec|
  spec.name          = "trax_controller"
  spec.version       = TraxController::VERSION
  spec.authors       = ["Jason Ayre"]
  spec.email         = ["jasonayre@gmail.com"]
  spec.summary       = %q{Resourceful, standardized controllers}
  spec.description   = %q{Resourceful, standardized controllers}
  spec.homepage      = "http://www.github.com/jasonayre"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "trax_core"
  spec.add_dependency "will_paginate"
  spec.add_dependency "has_scope"
  spec.add_development_dependency "rails"
  spec.add_development_dependency "inherited_resources"
  spec.add_development_dependency 'combustion', '~> 0.5.3'
  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-pride"
  spec.add_development_dependency "pry-nav"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency 'rspec-its', '~> 1'
  spec.add_development_dependency 'rspec-collection_matchers', '~> 1'
  spec.add_development_dependency 'guard', '~> 2'
  spec.add_development_dependency 'guard-rspec', '~> 4'
  spec.add_development_dependency 'guard-bundler', '~> 2'
  spec.add_development_dependency 'rb-fsevent'
  spec.add_development_dependency 'terminal-notifier-guard'

end
