require 'pry'

describe Grape::Roar::Extensions::RelationalModels::DSLMethods do
  subject do 
    Class.new.tap { |c| c.singleton_class.include(described_class) }
  end

  context '#link_relation' do 
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

  context '#link_self' do
    after { subject.link_self }

    it 'calls the method correctly' do
      expect(subject).to receive(:link).with(:self)
    end
  end

  context '#name_for_represented' do
    let(:represented) { double }

    after { subject.name_for_represented(represented) }

    it 'calls the methods correctly' do
      expect(subject).to receive_message_chain(
        *%i(relational_mapper adapter name_for_represented)
      ).with(represented)
    end
  end

  context '#relation' do 
    let(:relational_mapper) { double }
    let(:relation_name) { double }
    let(:relation_kind) { :has_many }

    let(:opts) { {} }

    before do 
      allow(subject).to receive(:relational_mapper)
                    .and_return(relational_mapper)
    end

    after { subject.relation(relation_kind, relation_name, opts) }

    it 'correctly stores the info in mapper' do
      expect(relational_mapper).to receive(:[]=).with(
        relation_name, opts.merge(relation_kind: relation_kind)
      )
    end
  end

  context '#represent' do 
    let(:object) { double }
    let(:options) { double }

    let(:relations_mapped) { false }

    before do
      expect(subject).to receive(:relations_mapped)
                     .and_return(relations_mapped)
    end

    after { subject.represent(object, options) }

    it 'should map relations and invoke super' do
      expect(subject).to receive(:map_relations).with(object)
      expect(subject.superclass).to receive(:represent).with(object, options)
    end

    context 'with relations mapped' do
      
      let(:relations_mapped) { true }

      it 'should not map relations and invoke super' do
        expect(subject).to_not receive(:map_relations).with(object)
        expect(subject.superclass).to receive(:represent).with(object, options)
      end
    end
  end
end