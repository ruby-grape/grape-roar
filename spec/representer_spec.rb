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

  context 'representer' do
    before do
      subject.get('/article/:id') do
        Article.new(title: 'Lonestar', id: params[:id])
      end
    end

    it 'returns a hypermedia representation' do
      get '/article/666'
      expect(last_response.body).to eq '{"title":"Lonestar","id":"666","links":[{"rel":"self","href":"/article/666"}]}'
    end
  end
end
