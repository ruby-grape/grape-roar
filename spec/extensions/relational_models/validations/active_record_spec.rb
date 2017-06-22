require 'spec_helper'
require 'active_record'

describe Grape::Roar::Extensions::RelationalModels::Validations::ActiveRecord do
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

  before do
    expect(model_klass).to receive(:reflections).twice
      .and_return(reflections)
  end

  %w(
    belongs_to
    has_many
    has_one
    has_and_belongs_to_many
  ).each do |relation|
    context "##{relation}_valid?" do
      let(:relation_klass) do
        "::ActiveRecord::Reflection::#{relation.camelize}"\
          'Reflection'.constantize.allocate
      end

      let(:reflections) { { test: relation_klass, fail: Class.new } }

      it 'properly validates the relation' do
        expect(subject.send("#{relation}_valid?", :test)).to eql(true)
        expect { subject.send("#{relation}_valid?", :fail) }.to raise_error(
          Grape::Roar::Extensions::RelationalModels::\
          Exceptions::InvalidRelationError
        )
      end
    end
  end
end
