# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY

  s.name        = 'spree_active_shipping'
  s.version     = '3.2.0.alpha'
  s.authors     = 'Sean Schofield'
  s.email       = 'sean@spreecommerce.com'
  s.homepage    = 'http://github.com/spree-contrib/spree_active_shipping'
  s.summary     = 'Spree extension for providing shipping methods that wrap the active_shipping plugin.'
  s.description = 'Spree extension for providing shipping methods that wrap the active_shipping plugin.'
  s.required_ruby_version = '>= 2.1.0'
  s.rubygems_version      = '>= 1.8.23'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ["lib"]

  s.add_dependency 'spree_core', '>= 3.1.0', '< 4.0'
  s.add_dependency 'active_shipping', '~> 1.4'
  s.add_dependency 'spree_extension'

  s.add_development_dependency 'pry'
  s.add_development_dependency 'webmock'
  s.add_development_dependency 'sass-rails'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'rspec-activemodel-mocks'
  s.add_development_dependency 'pg'
  s.add_development_dependency 'mysql2'
  s.add_development_dependency 'appraisal'
end
