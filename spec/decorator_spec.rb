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
    context 'with a single resource' do
      before do
        subject.get('/user/:id') do
          present User.new(name: 'Lonestar', id: params[:id]), with: UserRepresenter
        end
      end

      it 'returns a single hypermedia representation' do
        get '/user/666'
        expect(last_response.body).to eq '{"name":"Lonestar","id":"666","links":[{"rel":"self","href":"/user/666"}]}'
      end
    end

    context 'with an array of resources' do
      before do
        subject.get('/users') do
          present [User.new(name: 'Texassee', id: 1), User.new(name: 'Lonestar', id: 2)], with: UserRepresenter
        end
      end

      it 'returns an array of hypermedia representations' do
        get 'users'
        expect(last_response.body).to eq '[{"name":"Texassee","id":1,"links":[{"rel":"self","href":"/user/1"}]},{"name":"Lonestar","id":2,"links":[{"rel":"self","href":"/user/2"}]}]'
      end
    end
  end
end
