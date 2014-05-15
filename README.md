Grape::Roar
------------

A proof of concept for using [Roar](https://github.com/apotonick/roar) in [Grape](https://github.com/intridea/grape). This implementation doesn't do anything - Grape works with Roar out of the box, call `to_json` on representers or just return objects that include Roar representers.

[![Build Status](https://secure.travis-ci.org/dblock/grape-roar.png)](http://travis-ci.org/dblock/grape-roar)

Installation
------------

Add the `grape`, `roar` and `grape-roar` gems to Gemfile. Currently requires HEAD of Grape.

```ruby
gem 'grape', :git => "https://github.com/intridea/grape.git"
gem 'roar'
gem 'grape-roar'
```

And then execute:

    $ bundle

Usage
-----

### Require grape-roar

```ruby
# config.ru
require 'grape/roar'
```

### Tell your API to use Grape::Formatter::Roar

```ruby
class API < Grape::API
  format :json
  formatter :json, Grape::Formatter::Roar
end
```

Contributing
------------

Fork the project. Make your feature addition or bug fix with tests. Send a pull request. Bonus points for topic branches.

Copyright and License
---------------------

MIT License, see [LICENSE](http://github.com/dblock/grape-roar/raw/master/LICENSE) for details.

(c) 2012 [Daniel Doubrovkine](http://github.com/dblock), [Art.sy](http://artsy.github.com)
