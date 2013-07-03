module Signals

  # This is a Listener that once instantiated, will define a method that is
  # named what is passed as the action.
  class BlockListener
    attr_reader :event, :listener

    def initialize(event, &block)
      @listener = block
      @event = event
    end

    def execute_event(event, *args)
      if self.event == event
        self.listener.call(*args)
      end
    end
  end

end
