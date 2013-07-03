module Signals

  class Listener
    attr_reader :listener

    # @param [Object] listener the listener you want to use
    def initialize(listener)
      @listener = listener
    end

    # @param [Object] event
    # @return [void]
    def execute(event, *args)
      if @listener.respond_to?(event)
        @listener.send(event, *args)
      end
      nil
    end
  end

end
