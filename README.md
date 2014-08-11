# adamantium

Create immutable objects with ease.

[![Gem Version](https://badge.fury.io/rb/adamantium.png)][gem]
[![Build Status](https://secure.travis-ci.org/dkubb/adamantium.png?branch=master)][travis]
[![Dependency Status](https://gemnasium.com/dkubb/adamantium.png)][gemnasium]
[![Code Climate](https://codeclimate.com/github/dkubb/adamantium.png)][codeclimate]
[![Coverage Status](https://coveralls.io/repos/dkubb/adamantium/badge.png?branch=master)][coveralls]

[gem]: https://rubygems.org/gems/adamantium
[travis]: https://travis-ci.org/dkubb/adamantium
[gemnasium]: https://gemnasium.com/dkubb/adamantium
[codeclimate]: https://codeclimate.com/github/dkubb/adamantium
[coveralls]: https://coveralls.io/r/dkubb/adamantium

This is a small standalone gem featuring a module extracted from [axiom](https://github.com/dkubb/axiom).
It allows you to make objects immutable in a simple, unobtrusive way.

## Examples

``` ruby
require 'adamantium'
require 'securerandom'

class Example
  # Inclusion of Adamantium defaults to deep freeze behavior
  # of constructor and memoizer

  include Adamantium

  # Instance and attributes (ivars) are frozen per default
  # Example:
  #
  # object = Example.new
  # object.frozen?           # => true
  # object.attribute.frozen? # => true
  #
  def initialize
    @attribute = "foo bar"
  end
  attr_reader :attribute

  # Memoized method with deeply frozen value (default)
  # Example:
  #
  # object = Example.new
  # object.random => ["abcdef"]
  # object.random => ["abcdef"]
  # object.random.frozen? => true
  # object.random[0].frozen? => true
  #
  def random
    [SecureRandom.hex(6)]
  end
  memoize :random

  # Memoized method with non frozen value
  # Example:
  #
  # object = Example.new
  # object.buffer         # => <StringIO:abcdef>
  # object.buffer         # => <StringIO:abcdef>
  # object.buffer.frozen? # => false
  #
  def buffer
    StringIO.new
  end
  memoize :buffer, freezer: :noop

  # Memoized method with shallow frozen value
  # Example:
  #
  # object = Example.new
  # object.random2 => ["abcdef"]
  # object.random2 => ["abcdef"]
  # object.random2.frozen? => true
  # object.random2[0].frozen? => false
  #
  def random2
    [SecureRandom.hex(6)]
  end
  memoize :random2, freezer: :flat

  # Transform method derives changed instances without
  # calling the constructor
  # Example:
  #
  # object = Example.new
  # object.random => ["abcdef"]
  # update = object.edit "baz quux"
  # update.random => ["abcdef"]
  # update.attribute => "baz quux"
  #
  def edit(attribute)
    transform do
      @attribute = attribute
    end
  end
end

class FlatExample
  # Inclusion of Adamantium::Flat defaults to shallow frozen
  # behavior for memoizer and constructor

  include Adamantium::Flat

  # Instance is frozen but attribute is not
  # Example:
  #
  # object = FlatExample.new
  # object.frozen?           # => true
  # object.attribute.frozen? # => false
  #
  def initialize
    @attribute = "foo bar"
  end
  attr_reader :attribute

  # Memoized method with flat frozen value (default with Adamantium::Flat)
  # Example:
  #
  # object = Example.new
  # object.random => ["abcdef"]
  # object.random => ["abcdef"]
  # object.random.frozen? => true
  # object.random[0].frozen? => false
  #
  def random
    [SecureRandom.hex(6)]
  end
  memoize :random
end
```

## Usage with equalizer

Adamanitum may be used with [equalizer](https://www.github.com/dkubb/equalizer)
as long as equalizer is included into the class first, eg:

```ruby
class Foo
  include Equalizer.new(:foo)
  include Adamantium
end
```

Another, less common form is to include all the modules in a single line. It is
important to note that ruby includes the modules in reverse order, starting
with the last module and working backwards, eg:

```ruby
class Foo
  # equalizer will be mixed in first, then adamantium
  include Adamantium, Equalizer.new(:foo)
end
```

## Credits

* Dan Kubb ([dkubb](https://github.com/dkubb))
* Markus Schirp ([mbj](https://github.com/mbj))

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for details.

## Copyright

Copyright &copy; 2012-2014 Dan Kubb. See LICENSE for details.
