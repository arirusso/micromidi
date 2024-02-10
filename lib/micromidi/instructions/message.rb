module MicroMIDI

  module Instructions

    # Commands that deal with MIDI messages
    class Message

      # @param [State] state
      def initialize(state)
        @state = state
      end

      # Create a MIDI control change message
      # @param [Integer, String] id Control name or index
      # @param [Integer] value
      # @param [Hash] options
      # @option options [Integer] :channel
      # @return [MIDIMessage::ControlChange]
      def control_change(id, value, options = {})
        properties = @state.message_properties(options, :channel)
        if id.kind_of?(Integer)
          MIDIMessage::ControlChange.new(properties[:channel], id, value)
        else
          MIDIMessage::ControlChange[id].new(properties[:channel], value)
        end
      end

      # Create a MIDI note on message
      # @param [Integer, String] id Note name or index
      # @param [Hash] options
      # @option options [Integer] :channel
      # @option options [Integer] :velocity
      # @return [MIDIMessage::NoteOn]
      def note(id, options = {})
        properties = @state.message_properties(options, :channel, :velocity)
        note = note_message(MIDIMessage::NoteOn, id, properties)
        @state.last_note = note
        note
      end

      # Create a MIDI note off message
      # @param [Integer, String] id Note name or index
      # @param [Hash] options
      # @option options [Integer] :channel
      # @option options [Integer] :velocity
      # @return [MIDIMessage::NoteOff]
      def note_off(id, options = {})
        properties = @state.message_properties(options, :channel, :velocity)
        note_message(MIDIMessage::NoteOff, id, properties)
      end

      # Create a MIDI message from raw bytes
      # @param [Array<Integer>, Array<String>, String] message Byte string or array of numeric/string bytes
      # @return [MIDIMessage]
      def parse(message)
        MIDIMessage.parse(message)
      end

      # Create a MIDI program change message
      # @param [Integer] program
      # @param [Hash] options
      # @option options [Integer] :channel
      # @return [MIDIMessage::ProgramChange]
      def program_change(program, options = {})
        properties = @state.message_properties(options, :channel)
        MIDIMessage::ProgramChange.new(properties[:channel], program)
      end

      # Create a MIDI note-off message from the last note-on message
      # @return [MIDIMessage::NoteOff]
      def off
        note_off = @state.last_note.to_note_off unless @state.last_note.nil?
        @state.last_note = nil
        note_off
      end

      # Create a MIDI channel pressure message
      # @param [Integer] value
      # @param [Hash] options
      # @option options [Integer] :channel
      # @return [MIDIMessage::ChannelAftertouch]
      def channel_aftertouch(value, options = {})
        properties = @state.message_properties(options, :channel)
        MIDIMessage::ChannelAftertouch.new(properties[:channel], value)
      end
      alias_method :channel_pressure, :channel_aftertouch

      # Create a MIDI poly pressure message
      # @param [Integer, String] note
      # @param [Integer] value
      # @param [Hash] options
      # @option options [Integer] :channel
      # @return [MIDIMessage::PolyphonicAftertouch]
      def polyphonic_aftertouch(note, value, options = {})
        properties = @state.message_properties(options, :channel)
        MIDIMessage::PolyphonicAftertouch.new(properties[:channel], note, value)
      end
      alias_method :poly_aftertouch, :polyphonic_aftertouch
      alias_method :polyphonic_pressure, :polyphonic_aftertouch
      alias_method :poly_pressure, :polyphonic_aftertouch

      # Create a MIDI pitch bend message
      # @param [Integer] low
      # @param [Integer] high
      # @param [Hash] options
      # @option options [Integer] :channel
      # @return [MIDIMessage::PitchBend]
      def pitch_bend(low, high, options = {})
        properties = @state.message_properties(options, :channel)
        MIDIMessage::PitchBend.new(properties[:channel], low, high)
      end
      alias_method :bend, :pitch_bend
      alias_method :pitchbend, :pitch_bend

      protected

      # Parse a note name string eg "C4"
      # @param [String] name
      # @return [String]
      def parse_note_name(name)
        name = name.to_s
        octave = name.scan(/-?\d\z/).first
        string_options = { :octave => octave }
        note = name.split(/-?\d\z/).first
        string_properties = @state.message_properties(string_options, :octave)
        "#{note}#{string_properties[:octave].to_s}"
      end

      private

      # Create a MIDI note on or note off message
      # @param [Class] klass
      # @param [Integer, String] id
      # @param [Hash] properties
      # @return [MIDIMessage::NoteOn, MIDIMessage::NoteOff]
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
