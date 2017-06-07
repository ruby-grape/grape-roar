require 'spec_helper'
require 'active_record'

describe Grape::Roar::Extensions::RelationalModels::Validator::ActiveRecord do

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

  %w(belongs_to has_many).each do |relation|
    context "##{relation}_valid?" do
      let(:relation_klass) do
        "::ActiveRecord::Reflection::#{relation.camelize}Reflection".constantize
                                                                    .allocate
      end

      let(:reflections) { { test: relation_klass, fail: Class.new } }

      it 'properly validates the relation' do
        expect(subject.send("#{relation}_valid?", :test)).to eql(true)
        expect(subject.send("#{relation}_valid?", :fail)).to eql(false)
      end
    end
  end
end