#!/usr/bin/env ruby
#
module MicroMIDI

  module Instructions
    
    class SysEx

      include MIDIMessage
      
      def initialize(state)
        @state = state
      end

    end

  end

end