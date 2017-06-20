describe Grape::Roar::Extensions::RelationalModels::Mapper do
  let(:entity) { double }
  let(:klass)  { double }

  subject { described_class.new(entity) }

  context '#initialize' do
    it 'assigns the correct variables' do
      expect(subject.instance_variable_get(:@entity)).to eql(entity)
      expect(subject.instance_variable_get(:@config)).to eql({})
      subject
    end
  end
end