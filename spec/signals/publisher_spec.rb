require 'spec_helper'

describe Signals::Publisher do
  class DummyPublisher
    include Signals::Publisher
  end

  class SimpleListener
  end

  let(:publisher) { DummyPublisher.new }

  describe '#broadcast' do
    it 'should broadcast an event' do
      listener = double('AListener', execute: true)
      publisher.stub(listeners: Set.new([listener]))

      publisher.broadcast(:event, 1, 2)

      listener.should have_received(:execute).with(:event, 1, 2)
    end
  end

  describe '#subscribe' do
    it 'should subscribe a listener' do
      expect {
        publisher.subscribe(SimpleListener.new)
      }.to_not raise_error
    end
  end

  describe '#on' do
    it 'should subscribe a block listener' do
      publisher.stub(listeners: double('Set', add: true))

      publisher.on(:event) { true }

      publisher.listeners.should have_received(:add).once
    end
  end

  describe '#listeners' do
    subject { publisher.listeners }
    it { should be_a(Set) }
  end
end
