require 'spec_helper'

describe Signals::Subscriber do
  class DummySubscriber
    include Signals::Subscriber

    listen_for :event => :action_1
    listen_for :complex => [:action_2, :action_3]
    listen_for [:event, :complex] => :action_4
    listen_for [:event, :complex] => [:action_5, :action_6]
  end

  describe '#call' do
    context 'when the event is disabled' do
      it 'should not execute the actions' do
        subscriber = DummySubscriber.new
        subscriber.stub(event_enabled?: false, action_1: true)

        subscriber.call(:event)

        subscriber.should_not have_received(:action_1)
      end
    end

    context 'when the event is enabled' do
      it 'should execute the actions' do
        subscriber = DummySubscriber.new
        subscriber.stub(event_enabled?: true, action_1: true)

        subscriber.call(:event)

        subscriber.should have_received(:action_1).once
      end
    end
  end


  describe '#disable_event' do
    it 'should disable an event' do
      subscriber = DummySubscriber.new
      events = double('Events', add: true)
      subscriber.stub(disabled_events: events)

      subscriber.disable_event(:event)

      events.should have_received(:add).with(:event).once
    end
  end


  describe '#enable_event' do
    it 'should enable an event' do
      subscriber = DummySubscriber.new
      events = double('Events', delete: true)
      subscriber.stub(disabled_events: events)

      subscriber.enable_event(:event)

      events.should have_received(:delete).with(:event).once
    end
  end


  describe '#event_disabled?' do
    context 'when an event is disabled' do
      it 'should return true' do
        subscriber = DummySubscriber.new
        set = Set.new([:event])
        subscriber.stub(disabled_events: set)

        subscriber.event_disabled?(:event).should be_true
      end
    end

    context 'when an event is enabled' do
      it 'should return false' do
        subscriber = DummySubscriber.new
        set = Set.new([])
        subscriber.stub(disabled_events: set)

        subscriber.event_disabled?(:event).should be_false
      end
    end
  end


  describe '#event_enabled?' do
    context 'when an event is disabled' do
      it 'should return false' do
        subscriber = DummySubscriber.new
        set = Set.new([:event])
        subscriber.stub(disabled_events: set)

        subscriber.event_enabled?(:event).should be_false
      end
    end

    context 'when an event is enabled' do
      it 'should return true' do
        subscriber = DummySubscriber.new
        set = Set.new([])
        subscriber.stub(disabled_events: set)

        subscriber.event_enabled?(:event).should be_true
      end
    end
  end


  describe '#event?' do
    context 'when the event is on the subscriber' do
      it 'should return true' do
        subscriber = DummySubscriber.new
        subscriber.event?(:event).should be_true
      end
    end

    context 'when the event is not on the subscriber' do
      it 'should return false' do
        subscriber = DummySubscriber.new
        subscriber.event?(:not_here).should be_false
      end
    end
  end


  describe '#actions_for' do
    context 'when the event is on the subscriber' do
      it 'should return return its actions' do
        subscriber = DummySubscriber.new
        subscriber.actions_for(:event).should eq([:action_1, :action_4, :action_5, :action_6])
      end
    end

    context 'when the event is not on the subscriber' do
      it 'should return false' do
        subscriber = DummySubscriber.new
        subscriber.actions_for(:not_here).should eq([])
      end
    end
  end


  describe '#disabled_events' do
    context 'when no events are disabled' do
      it 'should be an empty set' do
        subscriber = DummySubscriber.new
        subscriber.disabled_events.should be_empty
      end
    end

    context 'when an event is disabled' do
      it 'should not be empty' do
        subscriber = DummySubscriber.new
        subscriber.disable_event(:event)
        subscriber.disabled_events.should_not be_empty
      end
    end
  end


  describe '#events' do
    it 'should not be empty' do
      subscriber = DummySubscriber.new
      subscriber.events.should_not be_empty
    end
  end


  describe '.listen_for' do
    class SubscriberListenTest
      include Signals::Subscriber
    end
    let(:klass) { SubscriberListenTest }
    context 'when the event is a symbol' do
      context 'when the action is a symbol' do
        it 'should register the action for the event' do
          klass.stub(add_event: true)

          klass.listen_for(:event_1 => :action_1)

          klass.should have_received(:add_event).with(:event_1, :action_1)
        end
      end

      context 'when the action is an array of symbols' do
        it 'should register the actions for the event' do
          klass.stub(add_event: true)

          klass.listen_for(:event_1 => [:action_2, :action_3])

          klass.should have_received(:add_event).with(:event_1, [:action_2, :action_3])
        end
      end
    end

    context 'when the event is an array of symbols' do
      context 'when the action is a symbol' do
        it 'should register the action for the events' do
          klass.stub(add_event: true)

          klass.listen_for([:event_2, :event_3] => :action_1)

          klass.should have_received(:add_event).twice
        end
      end
      context 'when the action is an array of symbols' do
        it 'should register the actions for the events' do
          klass.stub(add_event: true)

          klass.listen_for([:event_2, :event_3] => [:action_1, :action_2])

          klass.should have_received(:add_event).twice
        end
      end
    end
  end


  describe '.add_event' do
    class SubscriberAddEvent
      include Signals::Subscriber
    end
    let(:klass) { SubscriberAddEvent }

    context 'when the actions is an array of symbols' do
      it 'should be successful' do
        hash = double('Hash', concat: true)
        klass.stub(event: hash)

        klass.add_event(:event_1, [:action_1, :action_2])

        klass.should have_received(:event).with(:event_1)
      end
    end
    context 'when the action is a symbol' do
      it 'should be successful' do
        hash = double('Hash', concat: true)
        klass.stub(event: hash)

        klass.add_event(:event_1, :action_3)

        klass.should have_received(:event).with(:event_1)
      end
    end
  end


  describe '.events' do
    subject { DummySubscriber.events }
    it { should_not be_empty }

    class AnotherSubscriber
      include Signals::Subscriber
    end

    describe AnotherSubscriber do
      describe '.events' do
        subject { AnotherSubscriber.events }
        it { should be_empty }
      end
    end
  end


  describe '.event' do
    it 'should raise an exception' do
      expect {
        DummySubscriber.event(1)
      }.to raise_error
    end
  end
end
