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
end
