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

  # Is the given device a MIDI input?
  # @param [Object] device
  # @return [Boolean]
  def input?(device)
    device.respond_to?(:type) && device.type == :input && device.respond_to?(:gets)
  end

  # Is the given device a MIDI output?
  # @param [Object] device
  # @return [Boolean]
  def output?(device)
    device.respond_to?(:puts)
  end

  # Select the MIDI inputs from the given objects
  # @params [*Object] args
  # @return [Array<UniMIDI::Input>]
  def get_inputs(*args)
    [args].flatten.select { |device| input?(device) }
  end

  # Select the MIDI outputs from the given objects
  # @params [*Object] args
  # @return [Array<UniMIDI::Output, IO>]
  def get_outputs(*args)
    [args].flatten.select { |device| output?(device) }
  end

end
