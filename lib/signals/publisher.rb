module Signals

  module Publisher

    def self.included(base)
      base.send(:include, InstanceMethods)
    end

    module InstanceMethods
      # Broadcasts an event to all of the subscribed listeners
      # @return [void]
      def broadcast(event, *args)
        listeners.each do |listener|
          listener.execute_event(event, *args)
        end
        nil
      end

      # Creates a one off listener that will respond to the event provided only
      # @param [Object] event the event that is triggered
      # @return [void]
      def on(event, &block)
        listeners.add(BlockListener.new(event, &block))
        nil
      end

      # Subscribe a listener to the publisher
      # @param [Object] listener
      # @return [void]
      def subscribe(listener)
        listeners.add(listener)
        nil
      end

      # Unsubscribe a listener from the publisher
      # @param [Object] listener
      # @return [void]
      def unsubscribe(listener)
        listeners.delete(listener)
        nil
      end

      # All of the listeners subscribed to a publisher
      # @return [Set] a unique set of listeners
      def listeners
        @listeners ||= Set.new
      end
    end
  end

end
