describe Grape::Roar::Extensions::RelationalModels do
  context '.included' do
    subject { Class.new }
    after { subject.include(described_class) }
    
    it 'mixes DSLMethods into the singleton class of its target' do
      expect(subject.singleton_class).to receive(:include).with(
        Grape::Roar::Extensions::RelationalModels::DSLMethods
      )
    end
  end
end