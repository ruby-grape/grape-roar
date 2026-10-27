# frozen_string_literal: true

require 'roar/json/hal'

describe Grape::Roar do
  include_context 'Grape API App'

  shared_examples 'native collection rendering' do
    before do
      representer.property :id
      representer.property :title
      representer.link(:self) do |opts|
        "#{Grape::Request.new(opts.fetch(:env)).base_url}/products/#{represented.id}"
      end
      stub_const('CollectionItemRepresenter', representer)

      records = [Product.new(id: 1, title: 'First'), Product.new(id: 2, title: 'Second')]
      subject.get('/products') do
        products = params[:empty] ? [] : records
        CollectionItemRepresenter.for_collection.prepare(products).to_hash(user_options: { env: env })
      end

      wrapper = Module.new do
        include Roar::JSON::HAL
        include Grape::Roar::Representer
      end
      wrapper.collection :entries, extend: representer, as: :products, embedded: true
      subject.get('/hal') { present records, with: wrapper }
    end

    it 'renders each item with request-aware links' do
      get '/products'

      expect(JSON.parse(last_response.body)).to eq(
        [
          { 'id' => 1, 'title' => 'First', 'links' => [{ 'rel' => 'self', 'href' => 'http://example.org/products/1' }] },
          { 'id' => 2, 'title' => 'Second', 'links' => [{ 'rel' => 'self', 'href' => 'http://example.org/products/2' }] }
        ]
      )
    end

    it 'renders an empty collection as an array' do
      get '/products', empty: 'true'

      expect(JSON.parse(last_response.body)).to eq([])
    end

    it 'preserves existing collection representers with an embedded envelope' do
      get '/hal'

      products = JSON.parse(last_response.body).fetch('_embedded').fetch('products')
      expect(products.map { |product| product.fetch('title') }).to eq(%w[First Second])
      expect(products.first.fetch('links')).to eq([{ 'rel' => 'self', 'href' => 'http://example.org/products/1' }])
    end
  end

  context 'with a module' do
    let(:representer) do
      Module.new do
        include Roar::JSON
        include Roar::Hypermedia
        include Grape::Roar::Representer
      end
    end

    it_behaves_like 'native collection rendering'
  end

  context 'with a decorator' do
    let(:representer) do
      Class.new(Grape::Roar::Decorator) do
        include Roar::JSON
        include Roar::Hypermedia
      end
    end

    it_behaves_like 'native collection rendering'
  end
end
