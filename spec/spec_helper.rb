# encoding: utf-8

require 'adamantium'
require 'devtools/spec_helper'

RSpec.configure do |config|
end

if RUBY_VERSION >= '1.9' and ENV['COVERAGE'] == 'true'
  require 'simplecov'
  SimpleCov.start do
    command_name 'spec:unit'
    add_filter   'spec'
  end
end
