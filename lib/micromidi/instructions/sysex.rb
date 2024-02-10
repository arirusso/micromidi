module MicroMIDI

  module Instructions

    class SysEx

      # @param [State] state
      def initialize(state)
        @state = state
      end

      # Create a sysex command message
      # @param [Integer] address
      # @param [Array<Integer>] data
      # @param [Hash] options
      # @option options [MIDIMessage::SystemExclusive::Node] :node (also :sysex_node)
      # @return [MIDIMessage::SystemExclusive::Command]
      def sysex_command(address, data, options = {})
        properties = sysex_properties(options)
        MIDIMessage::SystemExclusive::Command.new(address, data, :node => properties[:sysex_node])
      end
      alias_method :command, :sysex_command

      # Create a sysex request message
      # @param [Integer] address
      # @param [Integer] size
      # @param [Hash] options
      # @option options [MIDIMessage::SystemExclusive::Node] :node (also :sysex_node)
      # @return [MIDIMessage::SystemExclusive::Request]
      def sysex_request(address, size, options = {})
        properties = sysex_properties(options)
        MIDIMessage::SystemExclusive::Request.new(address, size, :node => properties[:sysex_node])
      end
      alias_method :request, :sysex_request

      # Create a generic sysex message
      # @param [Array<Integer>] data
      # @param [Hash] options
      # @option options [MIDIMessage::SystemExclusive::Node] :node (also :sysex_node)
      # @return [MIDIMessage::SystemExclusive::Message]
      def sysex_message(data, options = {})
        properties = sysex_properties(options)
        MIDIMessage::SystemExclusive::Message.new(data, :node => properties[:sysex_node])
      end
      alias_method :sysex, :sysex_message

      private

      # Get the message properties given the options hash
      # @param [Hash] options
      # @return [Hash]
      def sysex_properties(options)
        sysex_options = options.dup
        sysex_options[:sysex_node] ||= options.delete(:node)
        @state.message_properties(sysex_options, :sysex_node)
      end

    end

  end

end
