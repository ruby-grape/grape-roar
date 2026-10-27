# frozen_string_literal: true

describe Grape::Roar do
  subject(:app) { ProductsAPI }

  let(:record) { Product.new(id: 1, title: 'Original') }

  before do
    stub_const('ProductInputRepresenter', Class.new(Grape::Roar::Decorator))
    stub_const('ProductOutputRepresenter', Class.new(Grape::Roar::Decorator))
    stub_const('ProductsAPI', Class.new(Grape::API))
    readme = File.expand_path('../../README.md', __dir__)
    section = File.read(readme).split("### CRUD Endpoints\n", 2).fetch(1).split("\n### ", 2).first
    TOPLEVEL_BINDING.eval(section[/```ruby\n(.*?)```/m, 1], readme)

    allow(Product).to receive(:new).and_return(record)
    allow(Product).to receive(:find).with(1).and_return(record)
    allow(record).to receive_messages(save!: true, destroy!: record)
  end

  it 'creates a record without assigning output-only or undeclared fields' do
    post '/products', JSON.generate(product: { title: 'Lonestar', id: 999, admin: true }), 'CONTENT_TYPE' => 'application/json'

    expect(last_response.status).to eq(201)
    expect(JSON.parse(last_response.body)).to eq('id' => 1, 'title' => 'Lonestar')
  end

  it 'updates an existing record and saves it' do
    expect(record).to receive(:save!)

    patch '/products/1', JSON.generate(product: { title: 'Updated' }), 'CONTENT_TYPE' => 'application/json'

    expect(JSON.parse(last_response.body)).to eq('id' => 1, 'title' => 'Updated')
  end

  it 'does not clear fields omitted from a partial update' do
    patch '/products/1', JSON.generate(product: {}), 'CONTENT_TYPE' => 'application/json'

    expect(last_response.status).to eq(200)
    expect(record.title).to eq('Original')
  end

  it 'rejects invalid create input without saving' do
    expect(record).not_to receive(:save!)

    post '/products', JSON.generate(product: { title: '' }), 'CONTENT_TYPE' => 'application/json'

    expect(last_response.status).to eq(400)
  end

  it 'deletes the requested record' do
    expect(record).to receive(:destroy!)

    delete '/products/1'

    expect(last_response.status).to eq(200)
  end

  it 'propagates save failures instead of returning a successful representation' do
    allow(record).to receive(:save!).and_raise(ArgumentError, 'Save rejected')

    expect do
      post '/products', JSON.generate(product: { title: 'Lonestar' }), 'CONTENT_TYPE' => 'application/json'
    end.to raise_error(ArgumentError, 'Save rejected')
  end

  it 'propagates destruction failures instead of returning success' do
    allow(record).to receive(:destroy!).and_raise(ArgumentError, 'Destruction rejected')

    expect { delete '/products/1' }.to raise_error(ArgumentError, 'Destruction rejected')
  end
end
