# frozen_string_literal: true

describe Grape::Roar do
  include_context 'Grape API App'

  context 'using present' do
    before do
      subject.get('/product/:id') do
        present Product.new(title: 'Lonestar', id: params[:id]), with: ProductRepresenter
      end
    end

    it 'returns a hypermedia representation' do
      get '/product/666'
      expect(last_response.body).to eq '{"title":"Lonestar","id":"666","links":[{"rel":"self","href":"http://example.org/product/666"}]}'
    end
  end

  context 'with a serialized representation cache' do
    let(:cache) { {} }
    let(:expected_response) do
      {
        'title' => 'Lonestar',
        'id' => '666',
        'links' => [{ 'rel' => 'self', 'href' => 'http://example.org/cached/product/666' }]
      }
    end

    before do
      store = cache
      subject.get('/cached/product/:id') do
        serialized = store.fetch(request.url) do
          product = Product.new(title: 'Lonestar', id: params[:id])
          representation = ProductRepresenter.represent(product).to_hash(user_options: { env: env })
          store[request.url] = JSON.generate(representation)
        end
        JSON.parse(serialized)
      end
    end

    it 'returns a JSON object on cache misses and serialized cache hits' do
      expect(Product).to receive(:new).once.and_call_original
      responses = 2.times.map do
        get '/cached/product/666'
        JSON.parse(last_response.body)
      end

      expect(responses).to eq([expected_response, expected_response])
      expect(JSON.parse(cache.fetch('http://example.org/cached/product/666'))).to eq(expected_response)
    end

    it 'keeps cached request-dependent links separate for different URLs' do
      get 'https://first.example.org/cached/product/666'
      first_response = JSON.parse(last_response.body)
      get 'https://second.example.org/cached/product/666'
      second_response = JSON.parse(last_response.body)

      expect(first_response.fetch('links')).to eq([{ 'rel' => 'self', 'href' => 'https://first.example.org/cached/product/666' }])
      expect(second_response.fetch('links')).to eq([{ 'rel' => 'self', 'href' => 'https://second.example.org/cached/product/666' }])
      expect(cache.size).to eq(2)
    end
  end

  shared_examples 'representing hash values' do
    let(:property_key) { :some_property }
    let(:record) { { property_key => 'From a hash', internal: 'Not exposed' } }

    before do
      key = property_key
      representer.property :some_property, getter: ->(*) { fetch(key) }
      stub_const('HashRepresenter', representer)

      data = record
      subject.get('/hash') do
        present data, with: HashRepresenter
      end
    end

    it 'reads symbol keys and excludes undeclared entries' do
      get '/hash'

      expect(JSON.parse(last_response.body)).to eq('some_property' => 'From a hash')
    end

    context 'with string keys' do
      let(:property_key) { 'some_property' }

      it 'reads the explicitly configured string key' do
        get '/hash'

        expect(JSON.parse(last_response.body)).to eq('some_property' => 'From a hash')
      end
    end
  end

  context 'with a module-based hash representer' do
    let(:representer) do
      Module.new do
        include Roar::JSON
        include Grape::Roar::Representer
      end
    end

    it_behaves_like 'representing hash values'
  end

  context 'with a hash decorator' do
    let(:representer) do
      Class.new(Grape::Roar::Decorator) do
        include Roar::JSON
      end
    end

    it_behaves_like 'representing hash values'
  end
end
