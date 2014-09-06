module MicroMIDI

  def self.new(*args, &block)
    message(*args, &block)
  end

  def self.message(*args, &block)
    inputs = get_inputs(args)
    outputs = get_outputs(args)
    MicroMIDI::Context.new(inputs, outputs, &block)
  end
  class << self
    alias_method :using, :message
  end

  module IO

    def self.new(*args, &block)
      MicroMIDI.message(*args, &block)
    end

  end

  private

  def self.get_inputs(args)
    args.find_all { |device| device.respond_to?(:type) && device.type == :input && device.respond_to?(:gets) }
  end

  def self.get_outputs(args)
    args.find_all { |device| device.respond_to?(:puts) }  
  end

end
