module Signals

  module Publisher

    def self.included(base)
      base.send(:include, InstanceMethods)
    end

    module InstanceMethods
      # Broadcasts an event to all of the subscribed listeners
      def broadcast(event, *args)
        listeners.each do |listener|
          listener.call(event, *args)
        end
        args.one? ? args.first : args
      end

      # Creates a one off listener that will respond to the event provided only
      # @param [Object] event the event that is triggered
      def on(event, &block)
        listeners.add(BlockListener.new(event, &block))
      end

      # Subscribe a listener to the publisher
      # @param [Object] listener
      def subscribe(listener)
        listeners.add(listener)
      end

      # Unsubscribe a listener from the publisher
      # @param [Object] listener
      def unsubscribe(listener)
        listeners.delete(listener)
      end

      # All of the listeners subscribed to a publisher
      # @return [Set] a unique set of listeners
      def listeners
        @listeners ||= Set.new
      end
    end
  end

end
