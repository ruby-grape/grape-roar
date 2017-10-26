# frozen_string_literal: true

describe Grape::Roar do
  include_context 'Grape API App'

  context 'representer' do
    context 'with a known model' do
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

    context 'without an instance singleton' do 
      context 'as nil' do 
        before do 
          subject.get('/article/:id') do
            present(nil, with: ArticleRepresenter)
          end
        end

        it 'returns null' do
          get '/article/666'
          expect(last_response.body).to eq('null')
        end
      end

      context 'as another immediate value' do 
        before do 
          subject.get('/article/:id') do
            present(5, with: ArticleRepresenter)
          end
        end

        it 'returns null' do
          get '/article/666'
          expect(last_response.body).to eq('null')
        end
      end 
    end
  end
end
