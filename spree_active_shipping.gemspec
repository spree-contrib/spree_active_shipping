# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY

  s.name        = 'spree_active_shipping'
  s.version     = '3.2.0.alpha'
  s.authors     = ["Sean Schofield"]
  s.email       = 'sean@railsdog.com'
  s.homepage    = 'http://github.com/spree/spree_active_shipping'
  s.summary     = 'Spree extension for providing shipping methods that wrap the active_shipping plugin.'
  s.description = 'Spree extension for providing shipping methods that wrap the active_shipping plugin.'
  s.required_ruby_version = '>= 2.1.0'
  s.rubygems_version      = '>= 1.8.23'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ["lib"]

  s.add_dependency('spree_core', '>= 3.1.0', '< 4.0')
  s.add_dependency('active_shipping', '~> 1.4.2')
  s.add_development_dependency 'pry'
  s.add_development_dependency 'webmock'
  s.add_development_dependency 'sass-rails', '~> 5.0'
  s.add_development_dependency 'coffee-rails', '~> 4.1'
  s.add_development_dependency 'simplecov'
end
