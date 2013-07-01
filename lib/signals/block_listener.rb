module Signals

  # This is a Listener that once instantiated, will define a method that is
  # named what is passed as the action.
  class BlockListener
    # @param [String] action
    def initialize(action, &block)
      (class << self; self; end;).instance_eval do
        define_method(action, block)
      end
    end
  end

end
