require 'spec_helper'

describe Signals::Listener do

  describe '#execute' do
    it 'should execute an existing method with no params' do
      simple = double('SimpleListener', testing: true)
      listener = Signals::Listener.new(simple)

      listener.execute(:testing)

      listener.listener.should have_received(:testing).once
    end

    it 'should execute an existing method with params' do
      simple = double('SimpleListener', testing: true)
      listener = Signals::Listener.new(simple)

      listener.execute(:testing, 1, 2)

      listener.listener.should have_received(:testing).with(1, 2).once
    end

    it 'should not raise an error when the method does not exist' do
      simple = double('SimpleListener')
      listener = Signals::Listener.new(simple)

      expect { listener.execute(:testing) }.to_not raise_error
    end
  end
end
