module Signals

  module Publisher
    # Broadcasts an action to all of the subscribed listeners
    # @return [Signals::Publisher]
    def broadcast(action, *args)
      listeners.each do |listener|
        if listener.respond_to?(action)
          listener.send(action, *args)
        end
      end
      self
    end

    def on(event, &block)
      listeners << BlockListener.new(event, &block)
      self
    end

    # Subscribe a listener to the publisher
    # @return [Signals::Publisher]
    def subscribe(listener)
      listeners << listener
      self
    end

    private

    # All of the listeners subscribed to a publisher
    # @return [Set] a unique set of listeners
    def listeners
      @listeners ||= Set.new
    end
  end

end
