#!/usr/bin/env ruby
#
module MicroMIDI

  module Instructions
    
    module Composite
      
      def play(n, duration)
        msg = case n
          when Numeric, String then note(n)
          when MIDIMessage then n 
        end
        sleep(duration)
        off
        msg
      end
      
    end

  end

end
