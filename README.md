adamantium
==========

[![Build Status](https://secure.travis-ci.org/dkubb/adamantium.png)](http://travis-ci.org/dkubb/adamantium)
[![Dependency Status](https://gemnasium.com/dkubb/adamantium.png)](https://gemnasium.com/dkubb/adamantium)
[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/dkubb/adamantium)

This is a small standalone gem featuring a module ripped out from [veritas](https://github.com/dkubb/veritas).
It allows to make objects immutable in an unobtrusive way.

Installation
------------

There is no gem release yet so use git source.

In your **Gemfile**:

``` ruby
gem 'adamantium', :git => 'https://github.com/dkubb/adamantium.git'
```

Examples
--------

``` ruby
require 'adamantium'
require 'securerandom'

class Foo
  include Adamantium

  def bar
    SecureRandom.hex(6)
  end

  memoize :bar
end

object = Foo.new
object.bar  # => "abcdef"
# Value is memoized
object.bar  # => "abcdef"
# Returns the same object on all calls
object.bar.equal?(object.bar)  # => true
# Object is frozen
object.frozen?  # => true
```

Hints
-----

* Do not memoize methods that take arguments they are per definition not idempotent
* Memoized method results are not frozen.

Credits
-------

* Dan Kubb ([dkubb](https://github.com/dkubb))
* Markus Schirp ([mbj](https://github.com/mbj))

Contributing
-------------

* If you want your code merged into the mainline, please discuss the proposed changes with me before doing any work on it. This library is still in early development, and the direction it is going may not always be clear. Some features may not be appropriate yet, may need to be deferred until later when the foundation for them is laid, or may be more applicable in a plugin.
* Fork the project.
* Make your feature addition or bug fix.
  * Follow this [style guide](https://github.com/dkubb/styleguide).
* Add specs for it. This is important so I don't break it in a future version unintentionally. Tests must cover all branches within the code, and code must be fully covered.
* Commit, do not mess with Rakefile, version, or history. (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Run "rake ci". This must pass and not show any regressions in the metrics for the code to be merged.
* Send me a pull request. Bonus points for topic branches.

License
-------

Copyright (c) 2009-2012 Dan Kubb
Copyright (c) 2012 Markus Schirp (packaging)

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
