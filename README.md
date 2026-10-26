Grape::Roar
-----------

[![Gem Version](http://img.shields.io/gem/v/grape-roar.svg)](http://badge.fury.io/rb/grape-roar)
[![test](https://github.com/ruby-grape/grape-roar/actions/workflows/test.yml/badge.svg)](https://github.com/ruby-grape/grape-roar/actions/workflows/test.yml)
[![test-activerecord](https://github.com/ruby-grape/grape-roar/actions/workflows/test-activerecord.yml/badge.svg)](https://github.com/ruby-grape/grape-roar/actions/workflows/test-activerecord.yml)
[![test-mongodb](https://github.com/ruby-grape/grape-roar/actions/workflows/test-mongodb.yml/badge.svg)](https://github.com/ruby-grape/grape-roar/actions/workflows/test-mongodb.yml)

Use [Roar](https://github.com/apotonick/roar) with [Grape](https://github.com/intridea/grape).

## Table of Contents

- [Demo](#demo)
- [Installation](#installation)
- [Usage](#usage)
  - [Tell your API to use Grape::Formatter::Roar](#tell-your-api-to-use-grapeformatterroar)
  - [Use Grape’s Present](#use-grapes-present)
  - [Accessing the Request Inside a Representer](#accessing-the-request-inside-a-representer)
  - [Decorators](#decorators)
  - [Nested Representers](#nested-representers)
  - [Caching Representations](#caching-representations)
  - [Relation Extensions](#relation-extensions)
    - [Designing Representers](#designing-representers)
      - [Example Models](#example-models)
      - [Example Representers](#example-representers)
      - [Example Item](#example-item)
      - [Example Cart](#example-cart)
    - [Errors](#errors)
    - [Change how URLs are presented](#change-how-urls-are-presented)
      - [Override base URI mappings](#override-base-uri-mappings)
      - [Override resource URI mappings](#override-resource-uri-mappings)
    - [Designing Adapters](#designing-adapters)
      - [Example: ActiveRecord Adapter](#example-activerecord-adapter)
      - [Validations](#validations)
- [Contributing](#contributing)
- [Copyright and License](#copyright-and-license)

## Demo

See [grape-with-roar](https://github.com/ruby-grape/grape-with-roar).

## Installation

CI covers Grape 1.x through 4.x on compatible Ruby versions, including Ruby 4.0. Grape 1.x requires Rack 2.x; newer Grape versions are tested with Rack 3.x. See [CONTRIBUTING](CONTRIBUTING.md#bundle-install-and-test) for the core and ORM compatibility matrices and local test commands.

Add the `grape`, `roar` and `grape-roar` gems to Gemfile.

```ruby
gem 'grape'
gem 'roar'
gem 'grape-roar'
```

If you're upgrading from an older version of this gem, please see [UPGRADING](UPGRADING.md).

## Usage

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

  collection :entries, extend: ProductRepresenter, as: :products, embedded: true
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

### Nested Representers

Use `property` for a single nested object and `collection` for multiple objects, specifying the representer at each level with `extend:`. For example, notifications can contain comments, posts, and images:

```ruby
class ImageRepresenter < Grape::Roar::Decorator
  include Roar::JSON

  property :id
  property :url
end

class PostRepresenter < Grape::Roar::Decorator
  include Roar::JSON

  property :id
  property :title
  property :image, extend: ImageRepresenter
end

class CommentRepresenter < Grape::Roar::Decorator
  include Roar::JSON

  property :id
  property :body
  property :post, extend: PostRepresenter
end

class NotificationRepresenter < Grape::Roar::Decorator
  include Roar::JSON

  property :id
  property :comment, extend: CommentRepresenter
end

class NotificationsRepresenter < Grape::Roar::Decorator
  include Roar::JSON

  collection :entries, as: :notifications, extend: NotificationRepresenter
end
```

```ruby
get 'notifications' do
  present Notification.all, with: NotificationsRepresenter
end
```

The response has a top-level `notifications` array; each notification contains its `comment`, whose `post` contains an `image`. Each representer controls only its own object's attributes, so an image's `id` does not replace its post's `id`.

Decorators wrap objects instead of extending them with representer modules. This is useful when the same model instance is shared between notifications or rendered with different representations. Keep the nested objects separate and let Roar compose the response rather than merging child attributes into a parent's hash.

### Caching Representations

`present object, with: Representer` returns a represented object, not a plain data snapshot. Module representers extend the object and attach serialization state, which can include Procs that a cache backend cannot serialize. Do not cache the represented model itself or change `represent` to return JSON globally.

Instead, render a plain Hash with Roar's `to_hash` before storing it. For example, using your application's cache store as `CACHE`:

```ruby
get 'products/:id' do
  cache_key = ['product-representation', request.url]
  CACHE.fetch(cache_key) do
    product = Product.find(params[:id])
    ProductRepresenter.represent(product).to_hash(user_options: { env: env })
  end
end
```

Return the cached Hash directly; the formatter encodes it as a JSON object. Do not call `present` on it with the model representer again, or cache a `to_json` string and return that through the JSON formatter, which would encode it a second time.

Rendering with `user_options: { env: env }` preserves request-aware links when populating the cache. The example includes the full request URL in the key because its self link depends on that URL. Include every other input that affects the response, such as authenticated user, locale, or header-based API version, in your cache key and invalidate cached representations when their source data changes. Alternatively, cache raw data and build a fresh model to present outside the cache block so request-dependent rendering runs on each request.

### Relation Extensions

If you use either `ActiveRecord` or `Mongoid`, you can use the `Grape::Roar::Extensions::Relations` DSL to expose the relationships in between your models as a HAL response. The DSL methods used are the same regardless of what your ORM/ODM is, as long as there exists [an adapter for it](#designing-adapters). 

#### Designing Representers

Arguments passed to `#relation` are forwarded to `roar`. Single member relations (e.g. `belongs_to`) are represented using `#property`, collections are represented using `#collection`; arguments provided to `#relation` will be passed through these methods (i.e. additional arguments [roar](https://github.com/trailblazer/roar) and [representable](http://trailblazer.to/gems/representable/3.0/api.html) accept).

A default base URI is constructed from a `Grape::Request` by concatenating the `#base_url` and `#script_name` properties. The resource path is extracted from the name of the relation.

Otherwise, the extensions attempt to look up the correct representer module/class for the objects (e.g. we infer the `extend` argument). You can always specify the correct representer to use on your own. 

##### Example Models

```ruby
class Item < ActiveRecord::Base
  belongs_to :cart
end

class Cart < ActiveRecord::Base
  has_many :items  
end
```

##### Example Representers

```ruby
class ItemEntity < Grape::Roar::Decorator
  include Roar::JSON
  include Roar::JSON::HAL
  include Roar::Hypermedia

  include Grape::Roar::Extensions::Relations

  # Cart will be presented under the _embedded key
  relation :belongs_to, :cart, embedded: true

  link_self
end

class CartEntity < Grape::Roar::Decorator
  include Roar::JSON
  include Roar::JSON::HAL
  include Roar::Hypermedia

  include Grape::Roar::Extensions::Relations

  # Items will be presented under the _links key
  relation :has_many, :items, embedded: false

  link_self
end
```

Although this example uses `Grape::Roar::Decorator`, you can also use a module as show in prior examples above. If doing so, you no longer have to mix in `Grape::Roar::Representer`. 

##### Example Item
```json
{
    "_embedded": {
        "cart": {
            "_links": {
                "self": {
                    "href": "http://example.org/carts/1"
                },
                "items": [{
                    "href": "http://example.org/items/1"
                }]
            }
        }
    },
    "_links": {
        "self": {
            "href": "http://example.org/items/1"
        }
    }
}
```

##### Example Cart
```json
{
    "_links": {
        "self": {
            "href": "http://example.org/carts/1"
        },
        "items": [{
            "href": "http://example.org/items/1"
        }, {
            "href": "http://example.org/items/2"
        }, {
            "href": "http://example.org/items/3"
        }, {
            "href": "http://example.org/items/4"
        }, {
            "href": "http://example.org/items/5"
        }]
    }
}
```

#### Errors

Should you incorrectly describe a relationship (e.g. you specify `has_one` but your model specifies `has_many`), an exception will be raised to notify you of the mismatch:

```ruby
Grape::Roar::Extensions::Relations::Exceptions::InvalidRelationError:
  Expected Mongoid::Association::Referenced::HasOne, got Mongoid::Association::Referenced::HasMany!
```

#### Change how URLs are presented

The `opts` hash below is the same one as shown in prior examples.

##### Override base URI mappings
```ruby
class BarEntity < Grape::Roar::Decorator
  include Roar::JSON
  include Roar::JSON::HAL
  include Roar::Hypermedia

  include Grape::Roar::Extensions::Relations

  # This is our default implementation
  map_base_url do |opts|
    request = Grape::Request.new(opts[:env])
    "#{request.base_url}#{request.script_name}"
  end

  relation :has_many, :bars, embedded: false
end
```

##### Override resource URI mappings
```ruby
class BarEntity < Grape::Roar::Decorator
  include Roar::JSON
  include Roar::JSON::HAL
  include Roar::Hypermedia

  include Grape::Roar::Extensions::Relations

  # This is our default implementation
  map_resource_path do |_opts, object, relation_name|
    "#{relation_name}/#{object.id}"
  end

  relation :has_many, :bars, embedded: false
end
```

#### Designing Adapters

If you have custom domain objects, you can create an adapter to make your models compatible with the DSL methods. Below is an example of the `ActiveRecord` adapter.

##### Example: ActiveRecord Adapter

```ruby
module Extensions
  module RelationalModels
    module Adapter
      class ActiveRecord < Base
        include Validations::ActiveRecord

        # We map your domain object to the correct adapter
        # at runtime.
        valid_for { |klass| klass < ::ActiveRecord::Base }

        def collection_methods
          @collection_methods ||= %i(has_many has_and_belongs_to_many)
        end

        def name_for_represented(represented)
          klass_name = case represented
                       when ::ActiveRecord::Relation
                         represented.klass.name
                       else
                         represented.class.name
                       end
          klass_name.demodulize.pluralize.downcase
        end

        def single_entity_methods
          @single_entity_methods ||= %i(has_one belongs_to)
        end
      end
    end
  end
end
```

##### Validations

Errors are handled by creating methods corresponding to those in `collection_methods` and `single_entity_methods`. For example, this is the validator for `belongs_to`:

```ruby
module ActiveRecord
  include Validations::Misc

  def belongs_to_valid?(relation)
    relation = klass.reflections[relation]

    return true if relation.is_a?(
      ::ActiveRecord::Reflection::BelongsToReflection
    )

    # Provided by Validations::Misc
    invalid_relation(
      ::ActiveRecord::Reflection::BelongsToReflection,
      relation.class
    )
  end
end
```

After writing your validation methods, just mix them into your adapter. You can choose to not write validation methods; they are only invoked if your adapter responds to them. 

## Contributing

See [CONTRIBUTING](CONTRIBUTING.md).

## Copyright and License

MIT License, see [LICENSE](LICENSE) for details.

(c) 2012-2025 [Daniel Doubrovkine](https://github.com/dblock) & Contributors, [Artsy](https://artsy.net)
