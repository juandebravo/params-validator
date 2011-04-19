require 'bundler'
require 'rake'
require 'rspec/core/rake_task'

Bundler::GemHelper.install_tasks

desc 'Default: run specs.'
task :default => :spec

desc "Run all specs"

RSpec::Core::RakeTask.new do |t|
    t.pattern = './spec/**/*_spec.rb'
end
