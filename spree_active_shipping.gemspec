# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY

  s.name        = 'spree_active_shipping'
  s.version     = '1.0.0'
  s.authors     = ["Sean Schofield"]
  s.email       = 'sean@railsdog.com'
  s.homepage    = 'http://github.com/spree/spree_active_shipping'
  s.summary     = 'Spree extension for providing shipping methods that wrap the active_shipping plugin.'
  s.description = 'Spree extension for providing shipping methods that wrap the active_shipping plugin.'
  s.required_ruby_version = '>= 1.8.7'
  s.rubygems_version      = '1.3.6'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ["lib"]

  s.add_dependency('spree_core', '>= 0.30.1')
  s.add_dependency('active_shipping', '0.9.12')
end
