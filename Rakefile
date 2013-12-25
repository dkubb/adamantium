# encoding: utf-8

require 'bundler'
Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

task :test    => :spec
task :default => :spec

require 'yardstick/rake/measurement'
Yardstick::Rake::Measurement.new do |measurement|
  measurement.output = 'measurement/report.txt'
end

require 'yardstick/rake/verify'
Yardstick::Rake::Verify.new do |verify|
  verify.threshold = 98
end

task :ci => [:spec, :verify_measurements]
