# frozen_string_literal: true

describe Grape::Roar do
  subject(:api) { Class.new(Grape::API) }

  before do
    api.format :json
    api.formatter :json, Grape::Formatter::Roar
  end

  def app
    api
  end

  shared_examples 'inferred model representations' do
    before do
      stub_const('LookupProduct', Class.new(Product))
      representer.property :id
      representer.property :title
      stub_const('LookupProduct::Entity', representer)

      api.get('/product') { present LookupProduct.new(id: 1, title: 'Lonestar') }

      override = Module.new do
        include Roar::JSON
        include Grape::Roar::Representer

        property :id
      end
      api.get('/explicit') { present LookupProduct.new(id: 1, title: 'Lonestar'), with: override }
    end

    it 'finds the model Entity without a with option' do
      get '/product'

      expect(JSON.parse(last_response.body)).to eq('id' => 1, 'title' => 'Lonestar')
    end

    it 'lets an explicit representer override inference' do
      get '/explicit'

      expect(JSON.parse(last_response.body)).to eq('id' => 1)
    end
  end

  context 'with a module' do
    let(:representer) do
      Module.new do
        include Roar::JSON
        include Grape::Roar::Representer
      end
    end

    it_behaves_like 'inferred model representations'
  end

  context 'with a decorator' do
    let(:representer) do
      Class.new(Grape::Roar::Decorator) { include Roar::JSON }
    end

    it_behaves_like 'inferred model representations'
  end

  context 'with an API-local mapping' do
    before do
      decorator = Class.new(Grape::Roar::Decorator) do
        include Roar::JSON

        property :title
      end
      api.represent Product, with: decorator
      api.get('/product') { present Product.new(title: 'Lonestar', id: 1) }
    end

    it 'uses the registered decorator without modifying the model' do
      get '/product'

      expect(JSON.parse(last_response.body)).to eq('title' => 'Lonestar')
      expect(Product.const_defined?(:Entity, false)).to be false
    end
  end
end
