# frozen_string_literal: true

describe Grape::Roar do
  subject(:app) { ProductsAPI }

  before do
    stub_const('ProductInputRepresenter', Class.new(Grape::Roar::Decorator))
    stub_const('ProductsAPI', Class.new(Grape::API))
    readme = File.expand_path('../../README.md', __dir__)
    section = File.read(readme).split("### Presenter Parameter Types\n", 2).fetch(1).split("\n### ", 2).first
    example = section[/```ruby\n(.*?)```/m, 1]
    TOPLEVEL_BINDING.eval(example, readme)
  end

  def post_product(value)
    post '/products', JSON.generate(product: value), 'CONTENT_TYPE' => 'application/json'
  end

  it 'coerces an object through the documented presenter and excludes undeclared fields' do
    post_product(title: 'Lonestar', id: 666, admin: true)

    expect(last_response.status).to eq(201), last_response.body
    expect(JSON.parse(last_response.body)).to eq('title' => 'Lonestar')
  end

  it 'rejects malformed or incomplete objects before constructing a model' do
    expect(Product).not_to receive(:new)
    statuses = [nil, 'not an object', [], {}, { title: 12 }].map do |value|
      post_product(value)
      last_response.status
    end

    expect(statuses).to eq([400, 400, 400, 400, 400])
  end

  it 'rejects blank titles' do
    statuses = ['', " \t"].map do |title|
      post_product(title: title)
      last_response.status
    end

    expect(statuses).to eq([400, 400])
  end

  it 'rejects a missing required parameter' do
    post '/products', '{}', 'CONTENT_TYPE' => 'application/json'

    expect(last_response.status).to eq(400)
    expect(JSON.parse(last_response.body).fetch('error')).to include('product')
  end
end
