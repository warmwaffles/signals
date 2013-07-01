require 'spec_helper'

describe Signals::Publisher do
  class DummyPublisher
    include Signals::Publisher
  end

  class DummySimpleListener
    def simple_method
      true
    end
  end

  class DummyComplexListener
    def complex_method(a, b)
      true
    end
  end

  describe '#broadcast' do
    it 'should broadcast to no listeners' do
      publisher = DummyPublisher.new
      expect { publisher.broadcast(:simple_method) }.to_not raise_error
    end

    it 'should broadcast to a simple listener' do
      publisher = DummyPublisher.new
      publisher.stub(:listeners).and_return([DummySimpleListener.new])
      expect { publisher.broadcast(:simple_method) }.to_not raise_error
    end

    it 'should broadcast to a complex listener' do
      publisher = DummyPublisher.new
      publisher.stub(:listeners).and_return([DummyComplexListener.new])
      expect { publisher.broadcast(:complex_method, 1, 2) }.to_not raise_error
    end

    it 'should broadcast an unsupported event to a listener' do
      publisher = DummyPublisher.new
      publisher.stub(:listeners).and_return([DummySimpleListener.new])
      expect { publisher.broadcast(:does_not_exist) }.to_not raise_error
    end

    context 'when providing too few arguments' do
      it 'should raise an argument error' do
        publisher = DummyPublisher.new
        publisher.stub(:listeners).and_return([DummyComplexListener.new])
        expect { publisher.broadcast(:complex_method, 1) }.to raise_error(/wrong number of arguments/)
      end
    end

    context 'when providing too many arguments' do
      it 'should raise an argument error' do
        publisher = DummyPublisher.new
        publisher.stub(:listeners).and_return([DummySimpleListener.new])
        expect { publisher.broadcast(:simple_method, 1) }.to raise_error(/wrong number of arguments/)
      end
    end
  end

  describe '#subscribe' do
    it 'should subscribe an object' do
      publisher = DummyPublisher.new
      expect { publisher.subscribe(Object.new) }.to_not raise_error
    end
  end

  describe '#on' do
    pending
  end

end
