module MicroMIDI

  extend self

  # Shortcut to create a new context
  # @param [*Object] args
  # @param [Proc] block
  # @return [Context]
  def new(*args, &block)
    inputs = get_inputs(args)
    outputs = get_outputs(args)
    Context.new(inputs, outputs, &block)
  end

  class << self
    alias_method :message, :new
    alias_method :using, :new
  end

  module IO

    # Shortcut to create a new context
    # @param [*Object] args
    # @param [Proc] block
    # @return [Context]
    def self.new(*args, &block)
      MicroMIDI.new(*args, &block)
    end

  end

  private

  def get_inputs(args)
    args.find_all { |device| device.respond_to?(:type) && device.type == :input && device.respond_to?(:gets) }
  end

  def get_outputs(args)
    args.find_all { |device| device.respond_to?(:puts) }
  end

end
