module MicroMIDI

  module Instructions
    
    module Composite
      
      #
      # plays a note or notes, for a certain duration.
      #
      # the first argument must be a note name (String), MIDIMessage::NoteOn object, or array of either
      # the last argument must be a Numeric (representing the duration)
      #
      # additional arguments should be note names or MIDIMessage::NoteOn objects and will 
      # be played as a chord with the first argument
      #
      def play(*args)
        raise "last argument must be a Numeric duration" unless args.last.kind_of?(Numeric)
        
        duration = args.pop
        note_or_notes = [args].flatten
        
        msgs = note_or_notes.map do |n|
          case n
            when Numeric, String then note(n)
            when MIDIMessage then n 
          end
        end
        
        sleep(duration)
        msgs.each { |msg| note_off(msg.note, :channel => msg.channel, :velocity => msg.velocity) }
        
        msgs.size > 1 ? msgs : msgs.first
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
