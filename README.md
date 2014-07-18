Grape::Roar
------------

Use [Roar](https://github.com/apotonick/roar) with [Grape](https://github.com/intridea/grape).

[![Build Status](https://secure.travis-ci.org/dblock/grape-roar.png)](http://travis-ci.org/dblock/grape-roar)

Installation
------------

Add the `grape`, `roar` and `grape-roar` gems to Gemfile. Currently requires HEAD of Grape.

```ruby
gem 'grape'
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

### Grape Present

You can use Grape's `present` keyword after including Grape::Roar::Presenter into a representer module.

```ruby
module ProductRepresenter
  include Roar::Representer::JSON
  include Roar::Representer::Feature::Hypermedia
  include Grape::Roar::Representer

  property :title
  property :id
end
```

```ruby
get 'product/:id' do
  present Product.find(params[:id]), with: ProductRepresenter
end
```

Contributing
------------

Fork the project. Make your feature addition or bug fix with tests. Send a pull request. Bonus points for topic branches.

Copyright and License
---------------------

MIT License, see [LICENSE](http://github.com/dblock/grape-roar/raw/master/LICENSE) for details.

(c) 2012-2014 [Daniel Doubrovkine](http://github.com/dblock), [Art.sy](http://artsy.github.com)
