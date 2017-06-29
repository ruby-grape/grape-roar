# frozen_string_literal: true

describe Grape::Roar::Extensions::Relations do
  context '.included' do
    subject { Class.new }
    after { subject.include(described_class) }

    it 'mixes DSLMethods into the singleton class of its target' do
      expect(subject.singleton_class).to receive(:include).with(
        Grape::Roar::Extensions::Relations::DSLMethods
      )
    end
  end

  context 'with mongoid', mongoid: true do
    include_context 'Grape API App'

    # Make sure Mongo is empty
    before(:each) { Mongoid::Config.purge! }

    let(:result) { JSON.parse(last_response.body) }

    context 'has_many, embedded: false' do
      before do
        subject.get('/carts/:id') do
          cart = Cart.create(id: params[:id])
          Array.new(5).map { Item.create(cart: cart) }
          present(cart, with: MongoidCartRepresenter)
        end

        get '/carts/1'
      end

      it 'correctly generates the self link' do
        expect(result['_links']['self']['href']).to eql(
          'http://example.org/carts/1'
        )
      end

      it 'correctly generates links for items' do
        expect(result['_links']['items'].map { |l| l['href'] }).to all(
          match(/^http:\/\/example\.org\/items\/[A-Za-z0-9]*$/)
        )
      end
    end

    context 'belongs_to, embedded: true' do
      before do
        subject.get('/items/:id') do
          present(
            Item.create(id: params[:id], cart: Cart.create),
            with: MongoidItemRepresenter
          )
        end

        get '/items/1'
      end

      it 'correctly generates the self link' do
        expect(result['_links']['self']['href']).to eql(
          'http://example.org/items/1'
        )
      end

      it 'correctly represents the embedded cart' do
        expect(result['_embedded']['cart']['_links']['self']['href'])
          .to match(/^http:\/\/example\.org\/carts\/[A-Za-z0-9]*$/)

        expect(result['_embedded']['cart']['_links']['items'].count).to eql(1)
        expect(result['_embedded']['cart']['_links']['items'].first).to eql(
          result['_links']['self']
        )
      end
    end
  end
end
