# encoding: utf-8

require 'adamantium'
require 'rspec'

# require spec support files and shared behavior
Dir[File.expand_path('../{support,shared}/**/*.rb', __FILE__)].each do |file|
  require file
end

RSpec.configure do |config|
end

if RUBY_VERSION >= '1.9' and ENV['COVERAGE'] == 'true'
  require 'simplecov'
  SimpleCov.start do
    command_name 'spec:unit'
    add_filter   'spec'
  end
end
