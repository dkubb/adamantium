# encoding: utf-8

require File.expand_path('../lib/adamantium/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name        = 'adamantium'
  gem.version     = Adamantium::VERSION.dup
  gem.authors     = ['Dan Kubb', 'Markus Schirp']
  gem.email       = %w[dan.kubb@gmail.com mbj@seonic.net]
  gem.description = 'Immutable extensions to objects'
  gem.summary     = gem.description
  gem.homepage    = 'https://github.com/dkubb/adamantium'

  gem.require_paths    = %w[lib]
  gem.files            = `git ls-files`.split($/)
  gem.test_files       = `git ls-files spec/{unit,integration}`.split($/)
  gem.extra_rdoc_files = %w[LICENSE README.md TODO]

  gem.add_runtime_dependency('backports', '~> 2.6.4')
  gem.add_runtime_dependency('ice_nine',  '~> 0.6.0')

  gem.add_development_dependency('rake',  '~> 0.9.2.2')
  gem.add_development_dependency('rspec', '~> 1.3.2')
  gem.add_development_dependency('yard',  '~> 0.8.3')
end
