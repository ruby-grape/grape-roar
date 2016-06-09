require 'spec_helper'

describe Grape::Roar do
  subject do
    Class.new(Grape::API)
  end

  before do
    subject.format :json
    subject.formatter :json, Grape::Formatter::Roar
  end

  def app
    subject
  end

  context 'using present' do
    context 'with a single resource' do
      before do
        subject.get('/product/:id') do
          present Product.new(title: 'Lonestar', id: params[:id]), with: ProductRepresenter
        end
      end

      it 'returns a hypermedia representation' do
        get '/product/666'
        expect(last_response.body).to eq '{"title":"Lonestar","id":"666","links":[{"rel":"self","href":"/product/666"}]}'
      end
    end

    context 'with an array of resources' do
      before do
        subject.get('/products') do
          present [Product.new(title: 'Texassee', id: 1), Product.new(title: 'Lonestar', id: 2)], with: ProductRepresenter
        end
      end

      it 'returns an array of hypermedia representations' do
        get 'products'
        expect(last_response.body).to eq '[{"title":"Texassee","id":1,"links":[{"rel":"self","href":"/product/1"}]},{"title":"Lonestar","id":2,"links":[{"rel":"self","href":"/product/2"}]}]'
      end
    end

    context 'with an array of resources as a resource' do
      before do
        subject.get('/products') do
          present [Product.new(title: 'Texassee', id: 1), Product.new(title: 'Lonestar', id: 2)], with: ProductsRepresenter
        end
      end

      it 'returns an array of hypermedia representations' do
        get 'products'
        expect(last_response.body).to eq [
          { 'title' => 'Texassee', 'id' => 1, 'links' => [{ 'rel' => 'self', 'href' => '/product/1' }] },
          { 'title' => 'Lonestar', 'id' => 2, 'links' => [{ 'rel' => 'self', 'href' => '/product/2' }] }
        ]
      end
    end
  end
end
