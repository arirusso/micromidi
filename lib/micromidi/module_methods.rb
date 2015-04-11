module MicroMIDI

  extend self

  # Shortcut to create a new context
  # @param [*Object] args
  # @param [Proc] block
  # @return [Context]
  def new(*args, &block)
    inputs = Device.get_inputs(args)
    outputs = Device.get_outputs(args)
    Context.new(inputs, outputs, &block)
  end

  class << self
    alias_method :message, :new
    alias_method :using, :new
  end

  module Session

    # Shortcut to create a new context
    # @param [*Object] args
    # @param [Proc] block
    # @return [Context]
    def self.new(*args, &block)
      MicroMIDI.new(*args, &block)
    end

  end

end
