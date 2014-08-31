module MicroMIDI

  module Instructions
    
    class Sticky
      
      def initialize(state)
        @state = state
      end

      # sets the sticky channel for the current block
      def channel(val = nil)
        val.nil? ? @state.channel : @state.channel = val
      end
      
      # sets the octave for the current block
      def octave(val = nil)
        val.nil? ? @state.octave : @state.octave = val
      end
      
      # sets the sysex node for the current block
      def sysex_node(*args)
        options = args.last.kind_of?(Hash) ? args.last : {}
        args.empty? ? @state.sysex_node : @state.sysex_node = MIDIMessage::SystemExclusive::Node.new(args.first, options)
      end
      alias_method :node, :sysex_node

      # sets the sticky velocity for the current block
      def velocity(val = nil)
        val.nil? ? @state.velocity : @state.velocity = val
      end
      
      #
      # toggles super_sticky mode, a mode where any explicit values used to create MIDI messages
      # automatically become sticky -- whereas normally the explicit value would only be used for 
      # the current message.
      #
      # e.g.
      #
      # note "C4", :channel => 5
      #
      # will have the exact same effect as
      # 
      # channel 5
      # note "C4"
      #
      # while in super sticky mode
      #
      def super_sticky
        @state.toggle_super_sticky
      end
      
    end

  end

end
