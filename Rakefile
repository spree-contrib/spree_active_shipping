# encoding: utf-8
require 'rubygems'
require 'rake'
require 'rake/testtask'

desc "Default Task"
task :default => [ :spec ]

gemfile = File.expand_path('../spec/test_app/Gemfile', __FILE__)
if File.exists?(gemfile) && %w(rcov spec cucumber).include?(ARGV.first.to_s)
  require 'bundler'
  ENV['BUNDLE_GEMFILE'] = gemfile
  Bundler.setup

  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new

  require 'cucumber/rake/task'
  Cucumber::Rake::Task.new do |t|
    t.cucumber_opts = %w{--format pretty}
  end

  desc "Run specs with RCov"
  RSpec::Core::RakeTask.new(:rcov) do |t|
    t.rcov = true
    t.rcov_opts = %w{ --exclude gems\/,spec\/,features\/}
    t.verbose = true
  end

end

desc "Regenerates a rails 3 app for testing"
task :test_app do
  SPREE_PATH = ENV['SPREE_PATH']
  raise "SPREE_PATH should be specified" unless SPREE_PATH
  require File.join(SPREE_PATH, 'lib/generators/spree/test_app_generator')
  class SpreeActiveShippingTestAppGenerator < Spree::Generators::TestAppGenerator
    def tweak_gemfile
      append_file 'Gemfile' do
<<-gems
gem 'spree_core', :path => '#{File.join(SPREE_PATH, 'core')}'
gem 'spree_auth', :path => '#{File.join(SPREE_PATH, 'auth')}'
gem 'spree_active_shipping', :path => '#{File.dirname(__FILE__)}'
gems
      end
    end

    def install_gems
      inside "test_app" do
        run 'rake spree_core:install'
        run 'rake spree_auth:install'
      end
    end

    def migrate_db
      run_migrations
    end
  end
  SpreeActiveShippingTestAppGenerator.start
end

namespace :test_app do
  desc 'Rebuild test and cucumber databases'
  task :rebuild_dbs do
    system("cd spec/test_app && rake db:drop db:migrate RAILS_ENV=test && rake db:drop db:migrate RAILS_ENV=cucumber")
  end
end


