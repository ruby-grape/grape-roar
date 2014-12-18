Grape::Roar
------------

Use [Roar](https://github.com/apotonick/roar) with [Grape](https://github.com/intridea/grape).

[![Build Status](https://secure.travis-ci.org/dblock/grape-roar.png)](http://travis-ci.org/dblock/grape-roar)

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

You can use Grape's `present` keyword after including Grape::Roar::Representer into a representer module.

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

Presenting collections works the same way. The following example returns an embedded set of products in the HAL Hypermedia format.

```ruby
module ProductsRepresenter
  include Roar::Representer::JSON::HAL
  include Roar::Representer::Feature::Hypermedia
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
  include Roar::Representer::JSON
  include Roar::Representer::Feature::Hypermedia
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
  include Roar::Representer::JSON
  include Roar::Representer::Feature::Hypermedia

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

MIT License, see [LICENSE](http://github.com/dblock/grape-roar/raw/master/LICENSE) for details.

(c) 2012-2014 [Daniel Doubrovkine](http://github.com/dblock), [Art.sy](http://artsy.github.com)
