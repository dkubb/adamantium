# encoding: utf-8

require 'rake'

require File.expand_path('../lib/immutable/version', __FILE__)

FileList['tasks/**/*.rake'].each { |task| import task }

task :default => :spec
