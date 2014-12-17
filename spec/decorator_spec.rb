require 'spec_helper'

describe Grape::Roar::Decorator do
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

  context 'decorator' do
    before do
      subject.get('/user/:id') do
        present User.new(name: 'Lonestar', id: params[:id]), with: UserRepresenter
      end
    end

    it 'returns a hypermedia representation' do
      get '/user/666'
      expect(last_response.body).to eq '{"name":"Lonestar","id":"666","links":[{"rel":"self","href":"/user/666"}]}'
    end
  end
end
