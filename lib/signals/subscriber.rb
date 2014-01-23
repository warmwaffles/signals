module Signals

  module Subscriber

    def self.included(base)
      base.extend(ClassMethods)
      base.send(:include, InstanceMethods)
    end

    module ClassMethods
      # Register the class to listen for specific events and react accordingly.
      # Any combination can be used. Listen for only accepts a hash as the
      # parameter.
      #
      # == Example
      #
      #   class Something
      #     include Signals::Subscriber
      #
      #     listen_for :one => :action
      #     listen_for :one => [:action, :another]
      #     listen_for :one => [:and_another]
      #     listen_for [:one, :two] => :action
      #     listen_for [:one, :two] => [:action]
      #     listen_for [:one] => [:and_another]
      #   end
      #
      # @param [Hash] params
      # @return [void]
      def listen_for(params={})
        params.each do |k, v|
          if k.is_a?(Array)
            k.each { |e| add_event(e, v) }
          else
            add_event(k, v)
          end
        end
        nil
      end

      # @param [Symbol] e the event
      # @param [Array|Symbol] actions the actions to be taken
      # @return [void]
      def add_event(e, actions)
        event(e).concat(actions.is_a?(Array) ? actions : [actions])
        nil
      end

      # @return [Hash]
      def events
        @events ||= Hash.new
      end

      private

      # @param [Symbol] key
      # @return [Array]
      def event(key)
        events[key] ||= Array.new
      end
    end

    module InstanceMethods
      # @param [Symbol] event
      # @return [void]
      def call(event, *args)
        if event_enabled?(event)
          actions_for(event).each do |action|
            self.send(action, *args) if self.respond_to?(action)
          end
        end
        args.one? ? args.first : args
      end

      # Disables an event temporarily
      # @param [Symbol] event
      def disable_event(event)
        disabled_events.add(event)
        self
      end

      # Enables an event that was disabled
      # @param [Symbol] event
      def enable_event(event)
        disabled_events.delete(event)
        self
      end

      # Checks to see if the event is disabled
      # @param [Symbol] event
      # @return [Boolean]
      def event_disabled?(event)
        disabled_events.include?(event)
      end

      # Checks to see if the event is enabled
      # @param [Symbol] event
      # @return [Boolean]
      def event_enabled?(event)
        !event_disabled?(event)
      end

      # Checks to see if the event is present
      # @param [Symbol] event
      # @return [Boolean]
      def event?(event)
        events.include?(event)
      end

      # Get actions for a specific event
      # @param [Symbol] event
      # @return [Array]
      def actions_for(event)
        self.events[event] || Array.new
      end

      # The set of disabled events
      # @return [Set] a set of disabled events
      def disabled_events
        @disabled_events ||= Set.new
      end

      # The hash of events that the subscriber is listening for
      # @return [Hash]
      def events
        self.class.events.freeze
      end
    end
  end

end
