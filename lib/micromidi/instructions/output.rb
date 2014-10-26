module MicroMIDI

  module Instructions

    # Commands that deal with MIDI output
    class Output

      extend Forwardable

      def_delegators :@state, :toggle_auto_output
      alias_method :auto_output, :toggle_auto_output

      # @param [State] state
      def initialize(state)
        @state = state
      end

      # Output a message or toggle the auto output mode
      # @param [MIDIMessage, Boolean] message A MIDI message to output, or a boolean to toggle auto-output mode
      # @return [MIDIMessage]
      def output(message)
        set_auto_output(message) if !!message === message # check for boolean
        unless message.nil?
          @state.outputs.each { |output| output.puts(message) }
        end
        message
      end

      # Set mode where messages are automatically outputted
      # @param [Boolean] is_on Whether to set the auto output mode to ON
      # @return [Boolean]
      def set_auto_output(is_on)
        @state.auto_output = is_on
      end

    end

  end

end
