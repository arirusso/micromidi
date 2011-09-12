#!/usr/bin/env ruby
#
module MicroMIDI

  module Instructions
    
    module Composite
      
      # play note n, wait <em>duration</em> seconds, then do note off for note n
      def play(n, duration)
        msg = case n
          when Numeric, String then note(n)
          when MIDIMessage then n 
        end
        sleep(duration)
        off
        msg
      end
      
      # sends a note off message for every note on every channel
      def all_off
        (0..15).each do |channel|
          (0..127).each do |note_num|
            note_off(note_num, :channel => channel)
          end
        end
        true
      end
      alias_method :quiet!, :all_off
      
    end

  end

end
