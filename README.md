Grape::Roar
------------

[![Gem Version](http://img.shields.io/gem/v/grape-roar.svg)](http://badge.fury.io/rb/grape-roar)
[![Build Status](http://img.shields.io/travis/dblock/grape-roar.svg)](https://travis-ci.org/dblock/grape-roar)
[![Dependency Status](https://gemnasium.com/dblock/grape-roar.svg)](https://gemnasium.com/dblock/grape-roar)
[![Code Climate](https://codeclimate.com/github/dblock/grape-roar.svg)](https://codeclimate.com/github/dblock/grape-roar)

Use [Roar](https://github.com/apotonick/roar) with [Grape](https://github.com/intridea/grape).

Demo
----

The [grape-with-roar](https://github.com/dblock/grape-with-roar) project deployed [here on heroku](http://grape-with-roar.herokuapp.com).

Installation
------------

Add the `grape`, `roar` and `grape-roar` gems to Gemfile.

```ruby
gem 'grape'
gem 'roar'
gem 'grape-roar'
```

If you're upgrading from an older version of this gem, please see [UPGRADING](UPGRADING.md).

Usage
-----

### Tell your API to use Grape::Formatter::Roar

```ruby
class API < Grape::API
  format :json
  formatter :json, Grape::Formatter::Roar
end
```

### Use Grape's Present

Include Grape::Roar::Representer into a representer module *after* any Roar mixins, then use Grape's `present` keyword.

```ruby
module ProductRepresenter
  include Roar::JSON
  include Roar::Hypermedia
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

Presenting collections works the same way. The following example returns an embedded set of products in the HAL Hypermedia format.

```ruby
module ProductsRepresenter
  include Roar::JSON::HAL
  include Roar::Hypermedia
  include Grape::Roar::Representer

  collection :entries, extend: ProductPresenter, as: :products, embedded: true
end
```

```ruby
get 'products' do
  present Product.all, with: ProductsRepresenter
end
```

### Accessing the Request Inside a Representer

The formatter invokes `to_json` on presented objects and provides access to the requesting environment via the `env` option. The following example renders a full request URL in a representer.

```ruby
module ProductRepresenter
  include Roar::JSON
  include Roar::Hypermedia
  include Grape::Roar::Representer

  link :self do |opts|
    request = Grape::Request.new(opts[:env])
    "#{request.url}"
  end
end
```

### Decorators

If you prefer to use a decorator class instead of modules.

```ruby
class ProductRepresenter < Grape::Roar::Decorator
  include Roar::JSON
  include Roar::Hypermedia

  link :self do |opts|
    "#{request(opts).url}/#{represented.id}"
  end

  private

  def request(opts)
    Grape::Request.new(opts[:env])
  end
end
```

```ruby
get 'products' do
  present Product.all, with: ProductsRepresenter
end
```

Contributing
------------

See [CONTRIBUTING](CONTRIBUTING.md).

Copyright and License
---------------------

MIT License, see [LICENSE](LICENSE) for details.

(c) 2012-2014 [Daniel Doubrovkine](https://github.com/dblock) & Contributors, [Artsy](https://artsy.net)
