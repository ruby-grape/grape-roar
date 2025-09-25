# frozen_string_literal: true

describe Grape::Roar::Extensions::Relations::DSLMethods do
  subject do
    Class.new.tap { |c| c.singleton_class.include(described_class) }
  end

  describe '#link_relation' do
    let(:relation) { double }
    let(:collection) { false }

    before do
      allow(subject).to receive(:link)
      allow(subject).to receive(:links)
    end

    after { subject.link_relation(relation, collection) }

    it 'calls the correct method' do
      expect(subject).to receive(:link).with(relation)
    end

    context 'with a collection of objects' do
      let(:collection) { true }

      it 'uses the links method' do
        expect(subject).to receive(:links).with(relation)
      end
    end
  end

  describe '#name_for_represented' do
    let(:represented) { double }

    after { subject.name_for_represented(represented) }

    it 'calls the methods correctly' do
      expect(subject).to receive_message_chain(
        :relational_mapper, :adapter, :name_for_represented
      ).with(represented)
    end
  end

  context 'with relational mapper' do
    let(:relational_mapper) { double }

    before do
      allow(subject).to receive(:relational_mapper)
        .and_return(relational_mapper)
    end

    describe '#relation' do
      let(:relation_name) { double }
      let(:relation_kind) { :has_many }
      let(:opts) { {} }

      after { subject.relation(relation_kind, relation_name, opts) }

      it 'correctly stores the info in mapper' do
        expect(relational_mapper).to receive(:[]=).with(
          relation_name, opts.merge(relation_kind: relation_kind)
        )
      end
    end

    describe '#link_self' do
      after { subject.link_self }

      it 'calls the method correctly' do
        expect(relational_mapper).to receive(:[]=).with(
          :self, { relation_kind: :self }
        )
      end
    end
  end

  describe '#map_base_url' do
    let(:grape_request) do
      OpenStruct.new(base_url: 'foo/', script_name: 'v1')
    end

    let(:opts) { { env: double } }

    before do
      allow(Grape::Request).to receive(:new).with(opts[:env])
                                            .and_return(grape_request)
    end

    it 'provides a default implementation' do
      expect(subject.map_base_url.call(opts)).to eql('foo/v1')
    end

    context 'with user provided block' do
      let(:block) { proc {} }

      it 'returns the user block' do
        subject.map_base_url(&block)
        expect(subject.map_base_url).to eql(block)
      end
    end
  end

  describe '#map_self_url' do
    after { subject.map_self_url }

    it 'calls the correct method' do
      expect(subject).to receive(:link).with(:self)
    end
  end

  describe '#map_resource_path' do
    let(:object)   { OpenStruct.new(id: 4) }
    let(:opts)     { double }
    let(:relation) { 'baz' }

    it 'provides a default implementation' do
      expect(
        subject.map_resource_path.call(opts, object, relation)
      ).to eql('baz/4')
    end

    context 'with user provided block' do
      let(:block) { proc {} }

      it 'returns the user block' do
        subject.map_resource_path(&block)
        expect(subject.map_resource_path).to eql(block)
      end
    end
  end

  describe '#represent' do
    let(:object) { double }
    let(:options) { double }

    let(:relations_mapped) { false }

    before do
      expect(subject).to receive(:relations_mapped)
        .and_return(relations_mapped)
    end

    after { subject.represent(object, options) }

    it 'maps relations and invoke super' do
      expect(subject).to receive(:map_relations).with(object)
      expect(subject.superclass).to receive(:represent).with(object, options)
    end

    context 'with relations mapped' do
      let(:relations_mapped) { true }

      it 'does not map relations and invoke super' do
        expect(subject).not_to receive(:map_relations).with(object)
        expect(subject.superclass).to receive(:represent).with(object, options)
      end
    end
  end
end
