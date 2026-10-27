# frozen_string_literal: true

describe Grape::Roar do
  include_context 'Grape API App'

  shared_examples 'rendering with request options' do
    before do
      representer.property :title
      representer.link(:self) { |opts| Grape::Request.new(opts.fetch(:env)).url }
      representer.link(:student) { |opts| "/students/#{opts.fetch(:student)}" }
      stub_const('RenderingRepresenter', representer)

      subject.get('/render') do
        product = Product.new(title: 'Lonestar')
        RenderingRepresenter.represent(product).to_hash(
          wrap: :product,
          user_options: { env: env, student: params[:student] }
        )
      end
    end

    it 'wraps the object and supplies callback data and the request environment' do
      get '/render', student: '123'

      expect(JSON.parse(last_response.body)).to eq(
        'product' => {
          'title' => 'Lonestar',
          'links' => [
            { 'rel' => 'self', 'href' => 'http://example.org/render?student=123' },
            { 'rel' => 'student', 'href' => '/students/123' }
          ]
        }
      )
    end

    it 'uses fresh callback options for each request' do
      links = %w[123 456].map do |student|
        get '/render', student: student
        JSON.parse(last_response.body).fetch('product').fetch('links').last.fetch('href')
      end

      expect(links).to eq(['/students/123', '/students/456'])
    end
  end

  context 'with a representer module' do
    let(:representer) do
      Module.new do
        include Roar::JSON
        include Roar::Hypermedia
        include Grape::Roar::Representer
      end
    end

    it_behaves_like 'rendering with request options'
  end

  context 'with a decorator' do
    let(:representer) do
      Class.new(Grape::Roar::Decorator) do
        include Roar::JSON
        include Roar::Hypermedia
      end
    end

    it_behaves_like 'rendering with request options'
  end
end
