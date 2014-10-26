module MicroMIDI

  module Instructions

    # Commands that deal with processing MIDI messages
    class Process

      # @param [State] state
      def initialize(state)
        @state = state
      end

      # Transpose a message value
      # @param [MIDIMessage] message
      # @param [Symbol, String] property
      # @param [Fixnum] factor
      # @param [Hash] options
      # @return [MIDIMessage]
      def transpose(message, property, factor, options = {})
        MIDIFX.transpose(message, property, factor, options)
      end

      # Limit a message value
      # @param [MIDIMessage] message
      # @param [Symbol, String] property
      # @param [Range] range
      # @param [Hash] options
      # @return [MIDIMessage]
      def limit(message, property, range, options = {})
        MIDIFX.limit(message, property, range, options)
      end

      # Filter a message value
      # @param [MIDIMessage] message
      # @param [Symbol, String] property
      # @param [Range] bandwidth
      # @param [Hash] options
      # @return [MIDIMessage]
      def filter(message, property, bandwidth, options = {})
        MIDIFX.filter(message, property, bandwidth, options)
      end

      # High pass filter a message value
      # @param [MIDIMessage] message
      # @param [Symbol, String] property
      # @param [Fixnum] min
      # @param [Hash] options
      # @return [MIDIMessage]
      def high_pass_filter(message, property, min, options = {})
        MIDIFX.high_pass_filter(message, property, min, options)
      end
      alias_method :only_above, :high_pass_filter
      alias_method :except_below, :high_pass_filter

      # Low pass filter a message value
      # @param [MIDIMessage] message
      # @param [Symbol, String] property
      # @param [Fixnum] max
      # @param [Hash] options
      # @return [MIDIMessage]
      def low_pass_filter(message, property, max, options = {})
        MIDIFX.low_pass_filter(message, property, max, options)
      end
      alias_method :only_below, :low_pass_filter
      alias_method :except_above, :low_pass_filter

      # Band pass filter a message value
      # @param [MIDIMessage] message
      # @param [Symbol, String] property
      # @param [Range] bandwidth
      # @param [Hash] options
      # @return [MIDIMessage]
      def band_pass_filter(message, property, bandwidth, options = {})
        MIDIFX.band_pass_filter(message, property, bandwidth, options)
      end
      alias_method :only_in, :band_pass_filter
      alias_method :only, :band_pass_filter

      # Band reject filter a message value
      # @param [MIDIMessage] message
      # @param [Symbol, String] property
      # @param [Range] bandwidth
      # @param [Hash] options
      # @return [MIDIMessage]
      def notch_filter(message, property, bandwidth, options = {})
        MIDIFX.notch_filter(message, property, bandwidth, options)
      end
      alias_method :band_reject_filter, :notch_filter
      alias_method :except_in, :notch_filter
      alias_method :except, :notch_filter

    end

  end

end
