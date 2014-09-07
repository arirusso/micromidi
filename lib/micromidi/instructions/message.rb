module MicroMIDI

  module Instructions
    
    class Message

      include MIDIMessage
      
      def initialize(state)
        @state = state
      end
      
      # create a control change message
      def control_change(id, value, opts = {})
        props = @state.message_properties(opts, :channel)
        id.kind_of?(Numeric) ? ControlChange.new(props[:channel], id, value) : ControlChange[id].new(props[:channel], value)
      end

      # create a note message
      def note(id, options = {})
        properties = @state.message_properties(options, :channel, :velocity)
        note = note_message(NoteOn, id, properties)
        @state.last_note = note
        note
      end

      # create a note off message
      def note_off(id, options = {})
        properties = @state.message_properties(options, :channel, :velocity)
        note_message(NoteOff, id, properties)
      end

      # create a MIDI message from a byte string, array of bytes, or list of bytes
      def parse(message)
        MIDIMessage.parse(message)
      end

      # create a program change message
      def program_change(program, opts = {})
        props = @state.message_properties(opts, :channel)
        MIDIMessage::ProgramChange.new(props[:channel], program)
      end

      # create a note-off message from the last note-on message
      def off
        o = @state.last_note.to_note_off unless @state.last_note.nil?
        @state.last_note = nil
        o
      end
      
      # create a channel pressure message
      def channel_aftertouch(value, opts = {})
        props = @state.message_properties(opts, :channel)
        MIDIMessage::ChannelAftertouch.new(props[:channel], value)
      end
      alias_method :channel_pressure, :channel_aftertouch
      
      # create a poly pressure message
      def polyphonic_aftertouch(note, value, opts = {})
        props = @state.message_properties(opts, :channel)
        MIDIMessage::PolyphonicAftertouch.new(props[:channel], note, value)
      end
      alias_method :poly_aftertouch, :polyphonic_aftertouch
      alias_method :polyphonic_pressure, :polyphonic_aftertouch
      alias_method :poly_pressure, :polyphonic_aftertouch
      
      def pitch_bend(low, high, opts = {})
        props = @state.message_properties(opts, :channel)
        MIDIMessage::PitchBend.new(props[:channel], low, high)
      end
      alias_method :bend, :pitch_bend
      alias_method :pitchbend, :pitch_bend
      
      protected
      
      def parse_note_name(name)
        name = name.to_s
        octave = name.scan(/-?\d\z/).first
        string_options = { :octave => octave }
        note = name.split(/-?\d\z/).first
        string_properties = @state.message_properties(string_options, :octave)
        "#{note}#{string_properties[:octave].to_s}"
      end

      private

      def note_message(klass, id, properties)
        if id.kind_of?(Numeric) 
          klass.new(properties[:channel], id, properties[:velocity])
        elsif id.kind_of?(String) || id.kind_of?(Symbol)
          note_name = parse_note_name(id)
          klass[note_name].new(properties[:channel], properties[:velocity])
        end
      end

    end

  end

end
