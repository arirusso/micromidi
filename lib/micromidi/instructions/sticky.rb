module MicroMIDI

  module Instructions

    # Commands that deal with sticky default properties.
    #
    # For example, setting a default MIDI channel that persists for the messages to follow it:
    #
    # ```ruby
    # channel 5
    # note "C4"
    # note "C3"
    # ```
    #
    class Sticky

      # @param [State] state
      def initialize(state)
        @state = state
      end

      # Gets/sets the sticky channel for the current block
      # @param [*Integer] args args[0] is an optional parameter to set the channel: [Integer, nil]
      # @return [Integer]
      def channel(*args)
        @state.channel = args.first unless args.empty?
        @state.channel
      end

      # Gets/sets the octave for the current block
      # @param [*Integer] args args[0] is an optional parameter to set the octave: [Integer, nil]
      # @return [Integer]
      def octave(*args)
        @state.octave = args.first unless args.empty?
        @state.octave
      end

      # Gets/sets the sysex node for the current block
      # @param [*Object] args
      # @return [MIDIMessage::SystemExclusive::Node]
      def sysex_node(*args)
        args = args.dup
        options = args.last.kind_of?(Hash) ? args.last : {}
        @state.sysex_node = MIDIMessage::SystemExclusive::Node.new(args.first, options) unless args.empty?
        @state.sysex_node
      end
      alias_method :node, :sysex_node

      # Gets/sets the sticky velocity for the current block
      # @param [*Integer] args args[0] is an optional parameter to set the velocity: [Integer, nil]
      # @return [Integer]
      def velocity(*args)
        @state.velocity = args.first unless args.empty?
        @state.velocity
      end

      #
      # Toggles super_sticky mode, a mode where any explicit values used to create MIDI messages
      # automatically become sticky.  Normally the explicit value would only be used for
      # the current message.
      #
      # For example, while in super sticky mode
      #
      # ```ruby
      # note "C4", :channel => 5
      # note "C3"
      # ```
      #
      # will have the same results as
      #
      # ```ruby
      # channel 5
      # note "C4"
      # note "C3"
      # ```
      #
      # @return [Boolean]
      def super_sticky
        @state.toggle_super_sticky
      end

    end

  end

end
