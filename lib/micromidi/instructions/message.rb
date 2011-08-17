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
      alias_method :cc, :control_change
      alias_method :c, :control_change

      # create a note message
      def note(id, opts = {})
        props = @state.message_properties(opts, :channel, :velocity)
        note = id.kind_of?(Numeric) ? NoteOn.new(props[:channel], id, props[:velocity]) : NoteOn[id].new(props[:channel], props[:velocity])
        @state.last_note = note
        note
      end
      alias_method :n, :note

      # create a note off message
      def note_off(id, opts = {})
        props = @state.message_properties(opts, :channel, :velocity)
        id.kind_of?(Numeric) ? NoteOff.new(props[:channel], id, props[:velocity]) : NoteOff[id].new(props[:channel], props[:velocity])
      end
      alias_method :no, :note_off

      # create a MIDI message from a byte string, array of bytes, or list of bytes
      def parse(message)
        MIDIMessage.parse(message)
      end
      alias_method :p, :parse

      # create a program change message
      def program_change(program, opts = {})
        props = @state.message_properties(opts, :channel)
        MIDIMessage::ProgramChange.new(props[:channel], program)
      end
      alias_method :pc, :program_change

      # create a note-off message from the last note-on message
      def off
        o = @state.last_note.to_note_off unless @state.last_note.nil?
        @state.last_note = nil
        o
      end
      alias_method :o, :off

    end

  end

end