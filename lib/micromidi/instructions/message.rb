#!/usr/bin/env ruby
#
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
      def note(id, opts = {})
        props = @state.message_properties(opts, :channel, :velocity)
        note = if id.kind_of?(Numeric) 
          NoteOn.new(props[:channel], id, props[:velocity])
        elsif id.kind_of?(String) 
          string_opts = { :octave => id.scan(/-?\d\z/).first }
          n = id.split(/-?\d\z/).first
          string_props = @state.message_properties(string_opts, :octave)
          note_string = "#{n}#{string_props[:octave].to_s}"
          NoteOn[note_string].new(props[:channel], props[:velocity])
        end
        @state.last_note = note
        note
      end

      # create a note off message
      def note_off(id, opts = {})
        props = @state.message_properties(opts, :channel, :velocity)
        id.kind_of?(Numeric) ? NoteOff.new(props[:channel], id, props[:velocity]) : NoteOff[id].new(props[:channel], props[:velocity])
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

    end

  end

end