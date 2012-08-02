# -*- encoding: utf-8 -*-

require File.expand_path('../lib/immutable/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name        = 'immutable'
  gem.version     = Immutable::VERSION.dup
  gem.authors     = [ 'Dan Kubb', 'Markus Schirp' ]
  gem.email       = [ 'dan.kubb@gmail.com', 'mbj@seonic.net' ]
  gem.description = 'Immutable extensions to objects'
  gem.summary     = gem.description
  gem.homepage    = 'https://github.com/mbj/immutable'

  gem.require_paths    = [ 'lib' ]
  gem.files            = `git ls-files`.split("\n")
  gem.test_files       = `git ls-files -- {spec}/*`.split("\n")
  gem.extra_rdoc_files = %w[LICENSE README.md TODO]
end
