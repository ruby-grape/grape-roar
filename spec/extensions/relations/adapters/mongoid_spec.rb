# frozen_string_literal: true

if defined?(Mongoid)
  describe Grape::Roar::Extensions::Relations::Adapters::Mongoid, :mongoid do
    let(:model) { Class.new.tap { |c| c.include(Mongoid::Document) } }

    subject { described_class.new(model) }

    describe '.valid_for?' do
      it 'is only valid for classes that mixed in Mongoid::Document' do
        expect(described_class.valid_for?(model)).to eql(true)
        expect(described_class.valid_for?('foo')).to eql(false)
      end
    end

    describe '#collection_methods' do
      it 'returns all collection methods' do
        expect(subject.collection_methods)
          .to match_array(%i[embeds_many has_many has_and_belongs_to_many])
      end
    end

    describe '#single_entity_methods' do
      it 'returns all single entity methods' do
        expect(subject.single_entity_methods)
          .to match_array(%i[has_one belongs_to embeds_one])
      end
    end
  end
end
