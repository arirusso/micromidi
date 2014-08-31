module MicroMIDI

  module Instructions
    
    class Process

      include MIDIMessage
      include MIDIMessage::Process
      
      def initialize(state)
        @state = state
      end
      
      def transpose(message, property, factor, options = {})
        Transpose.process(message, property, factor, options)
      end
      
      def limit(message, property, range, options = {})
        Limit.process(message, property, range, options)
      end
      
      def filter(message, property, bandwidth, options = {})
        Filter.process(message, property, bandwidth, options)
      end
      
      def high_pass_filter(message, property, min, options = {})
        HighPassFilter.process(message, property, min, options)
      end
      alias_method :only_above, :high_pass_filter
      alias_method :except_below, :high_pass_filter

      def low_pass_filter(message, property, max, options = {})
        LowPassFilter.process(message, property, max, options)
      end
      alias_method :only_below, :low_pass_filter
      alias_method :except_above, :low_pass_filter
      
      def band_pass_filter(message, property, bandwidth, options = {})
        BandPassFilter.process(message, property, bandwidth, options)
      end
      alias_method :only_in, :band_pass_filter
      alias_method :only, :band_pass_filter
      
      def notch_filter(message, property, bandwidth, options = {})
        NotchFilter.process(message, property, bandwidth, options)
      end
      alias_method :band_reject_filter, :notch_filter
      alias_method :except_in, :notch_filter
      alias_method :except, :notch_filter
      
    end

  end

end
