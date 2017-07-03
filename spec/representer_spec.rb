# frozen_string_literal: true



describe Grape::Roar do
  include_context 'Grape API App'

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
