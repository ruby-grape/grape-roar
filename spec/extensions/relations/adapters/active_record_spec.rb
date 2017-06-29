# frozen_string_literal: true
describe Grape::Roar::Extensions::Relations::Adapters::ActiveRecord, active_record: true do
  let(:model) { Class.new(ActiveRecord::Base) }
  subject { described_class.new(model) }

  context '.valid_for?' do
    it 'is only valid for ActiveRecord::Base descendants' do
      expect(described_class.valid_for?(model)).to eql(true)
      expect(described_class.valid_for?('foo')).to eql(false)
    end
  end

  context '#collection_methods' do
    it 'should return all collection methods' do
      expect(subject.collection_methods)
        .to match_array(%i[has_many has_and_belongs_to_many])
    end
  end

  context '#single_entity_methods' do
    it 'should return all single entity methods' do
      expect(subject.single_entity_methods)
        .to match_array(%i[has_one belongs_to])
    end
  end
end
