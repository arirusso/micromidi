module MicroMIDI

  module Instructions
    
    module Composite
      
      #
      # Plays a note or notes, for a certain duration.
      #
      # The first argument must be a note name (String), MIDIMessage::NoteOn object, or array of either
      # the last argument must be a Numeric (representing the duration)
      #
      # Additional arguments should be note names or MIDIMessage::NoteOn objects and will 
      # be played as a chord with the first argument.
      #
      def play(*args)
        raise "Last argument must be a Numeric duration" unless args.last.kind_of?(Numeric)
        
        duration = args.pop
        note_or_notes = [args].flatten
        messages = as_note_messages(note_or_notes)
        sleep(duration)
        send_note_offs(messages)
        
        messages.count > 1 ? messages : messages.first
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

      private

      def send_note_offs(messages)
        messages.each do |message| 
          note_off(message.note, :channel => message.channel, :velocity => message.velocity)
        end
      end

      def as_note_messages(note_or_notes)
        note_or_notes.map do |note|
          case note
            when Numeric, String then note(note)
            when MIDIMessage then note 
          end
        end
      end
      
    end

  end

end
