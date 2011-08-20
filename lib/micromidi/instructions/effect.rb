#!/usr/bin/env ruby
#
module MicroMIDI

  module Instructions
    
    class Effect

      include FX
      include MIDIMessage
      
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

      def low_pass_filter(message, property, max, options = {})
        LowPassFilter.process(message, property, max, options)
      end
      
      def band_pass_filter(message, property, bandwidth, options = {})
        BandPassFilter.process(message, property, bandwidth, options)
      end
      
      def notch_filter(message, property, bandwidth, options = {})
        NotchFilter.process(message, property, bandwidth, options)
      end
      alias_method :band_reject_filter, :notch_filter
      
    end

  end

end