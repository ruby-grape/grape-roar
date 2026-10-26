# frozen_string_literal: true

describe Grape::Roar do
  context 'nested representer' do
    include_context 'Grape API App'

    before do
      subject.get('/order/:id') do
        order = Order.new(id: params[:id], client_id: 42)
        order.articles << Article.new(title: 'One', id: 1)
        order.articles << Article.new(title: 'Two', id: 2)
        order
      end
    end

    it 'returns a hypermedia representation' do
      get '/order/666'
      expect(last_response.body).to eq '{"id":"666","client_id":42,"articles":[{"title":"One","id":1,"links":[{"rel":"self","href":"/article/1"}]},{"title":"Two","id":2,"links":[{"rel":"self","href":"/article/2"}]}],"links":[{"rel":"self","href":"/order/666"},{"rel":"items","href":"/order/666/items"}]}'
    end
  end

  context 'with deeply nested decorators' do
    include_context 'Grape API App'

    let(:record_class) { Struct.new(:id, :title, :url, :body, :image, :post, :comment, keyword_init: true) }
    let(:notifications) do
      first_post = record_class.new(id: 21, title: 'First post', image: record_class.new(id: 11, url: '/first.png'))
      second_post = record_class.new(id: 22, title: 'Second post', image: record_class.new(id: 12, url: '/second.png'))

      [first_post, second_post, first_post].each_with_index.map do |post, index|
        comment = record_class.new(id: index + 31, body: "Comment #{index + 1}", post: post)
        record_class.new(id: index + 1, comment: comment)
      end
    end
    let(:expected_posts) do
      first_post = { 'id' => 21, 'title' => 'First post', 'image' => { 'id' => 11, 'url' => '/first.png' } }
      second_post = { 'id' => 22, 'title' => 'Second post', 'image' => { 'id' => 12, 'url' => '/second.png' } }
      [first_post, second_post, first_post]
    end
    let(:expected_response) do
      {
        'notifications' => expected_posts.each_with_index.map do |post, index|
          { 'id' => index + 1, 'comment' => { 'id' => index + 31, 'body' => "Comment #{index + 1}", 'post' => post } }
        end
      }
    end

    before do
      stub_const('ImageRepresenter', Class.new(Grape::Roar::Decorator) do
        include Roar::JSON

        property :id
        property :url
      end)
      stub_const('PostRepresenter', Class.new(Grape::Roar::Decorator) do
        include Roar::JSON

        property :id
        property :title
        property :image, extend: ImageRepresenter
      end)
      stub_const('CommentRepresenter', Class.new(Grape::Roar::Decorator) do
        include Roar::JSON

        property :id
        property :body
        property :post, extend: PostRepresenter
      end)
      stub_const('NotificationRepresenter', Class.new(Grape::Roar::Decorator) do
        include Roar::JSON

        property :id
        property :comment, extend: CommentRepresenter
      end)
      stub_const('NotificationsRepresenter', Class.new(Grape::Roar::Decorator) do
        include Roar::JSON

        collection :entries, as: :notifications, extend: NotificationRepresenter
      end)

      records = notifications
      subject.get('/notifications') do
        present(params[:reverse] == 'true' ? records.reverse : records, with: NotificationsRepresenter)
      end
    end

    it 'keeps post and image attributes separate across shared records' do
      get '/notifications'

      expect(JSON.parse(last_response.body)).to eq(expected_response)
    end

    it 'preserves nested attributes when rendering the same objects in different orders' do
      responses = [false, true, false].map do |reverse|
        get '/notifications', reverse: reverse
        JSON.parse(last_response.body)
      end
      reversed_response = { 'notifications' => expected_response.fetch('notifications').reverse }

      expect(responses).to eq([expected_response, reversed_response, expected_response])
    end
  end
end
