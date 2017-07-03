# frozen_string_literal: true
describe Grape::Roar::Extensions::Relations::Validations::Mongoid, mongoid: true do
  let(:model_klass) { double }

  subject do
    klass = Class.new do
      def initialize(klass)
        @klass = klass
      end

      attr_reader :klass
    end

    klass.include(described_class)
    klass.new(model_klass)
  end

  let(:map_reflection) do
    proc do |r|
      case r
      when /and/     then 'ManyToMany'
      when /many/    then 'Many'
      when /one/     then 'One'
      when /belongs/ then 'In'
      end
    end
  end

  before do
    expect(model_klass).to receive(:reflect_on_association).twice do |r|
      if r == :test_rel
        {
          relation: "Mongoid::Relations::#{relation_klass}"\
                    "::#{map_reflection.call(test_method)}".constantize
        }
      else
        { relation: double }
      end
    end
  end

  context 'referenced' do
    let(:relation_klass) { 'Referenced' }

    %i[
      belongs_to
      has_and_belongs_to_many
      has_many
      has_one
    ].each do |test_method|
      context "##{test_method}_valid? validates the relation" do
        let(:test_method) { test_method }

        it 'properly validates the relation' do
          expect(subject.send("#{test_method}_valid?", :test_rel)).to eql(true)

          expect do
            subject.send("#{test_method}_valid?", :fail)
          end.to raise_error(
            Grape::Roar::Extensions::Relations::\
            Exceptions::InvalidRelationError
          )
        end
      end
    end
  end

  context 'referenced' do
    let(:relation_klass) { 'Embedded' }

    %i[embeds_one embeds_many].each do |test_method|
      context "##{test_method}_valid? validates the relation" do
        let(:test_method) { test_method }

        it 'properly validates the relation' do
          expect(subject.send("#{test_method}_valid?", :test_rel)).to eql(true)

          expect do
            subject.send("#{test_method}_valid?", :fail)
          end.to raise_error(
            Grape::Roar::Extensions::Relations::\
            Exceptions::InvalidRelationError
          )
        end
      end
    end
  end
end
