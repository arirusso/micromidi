module MicroMIDI

  module Device

    extend self

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
end
