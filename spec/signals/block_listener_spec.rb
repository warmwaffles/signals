require 'spec_helper'

describe Signals::BlockListener do

  describe '#execute' do
    it 'should execute the event it was registered for' do
      block = Signals::BlockListener.new(:testing)
      block.stub(listener: double('lambda', call: true))

      block.execute(:testing)

      block.listener.should have_received(:call).once
    end

    it 'should not execute when the event does not match' do
      block = Signals::BlockListener.new(:testing)
      block.stub(listener: double('lambda', call: true))

      block.execute(:another)

      block.listener.should_not have_received(:call)
    end

    it 'should pass parameters on to the proc' do
      block = Signals::BlockListener.new(:testing)
      block.stub(listener: double('lambda', call: true))

      block.execute(:testing, 1, 2)

      block.listener.should have_received(:call).with(1,2).once
    end
  end

end
