require 'spec_helper'

describe Signals::Publisher do
  class DummyPublisher
    include Signals::Publisher
  end

  describe '#broadcast' do
    it 'should broadcast an event to subscribers' do
      publisher = DummyPublisher.new
      listener  = double('Listener', call: true)
      listeners = [listener]
      publisher.stub(listeners: listeners)

      publisher.broadcast(:event, 1, 2)

      listener.should have_received(:call).with(:event, 1, 2)
    end
  end

  describe '#on' do
    it 'should should be successful' do
      publisher = DummyPublisher.new
      listeners = double('Set', add: true)
      publisher.stub(listeners: listeners)

      publisher.on(:event) do
        true
      end

      listeners.should have_received(:add).once
    end
  end

  describe '#subscribe' do
    it 'should subscribe a subscriber' do
      publisher = DummyPublisher.new
      listeners = double('Set', add: true)
      listener = double('Listener')
      publisher.stub(listeners: listeners)

      publisher.subscribe(listener)

      listeners.should have_received(:add).with(listener).once
    end
  end

  describe '#listeners' do
    subject { DummyPublisher.new.listeners }
    it { should be_a(Set) }
  end

end
