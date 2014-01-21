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
  gem.license     = 'MIT'

  gem.require_paths    = %w[lib]
  gem.files            = `git ls-files`.split("\n")
  gem.test_files       = `git ls-files -- spec/{unit,integration}`.split("\n")
  gem.extra_rdoc_files = %w[LICENSE README.md CONTRIBUTING.md TODO]

  gem.add_runtime_dependency('ice_nine',   '~> 0.11.0')
  gem.add_runtime_dependency('memoizable', '~> 0.4.0')

  gem.add_development_dependency('bundler', '~> 1.5', '>= 1.5.2')
end
