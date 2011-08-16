#!/usr/bin/env ruby
#
module MicroMIDI

  module Instructions
    
    class Message

      include MIDIMessage
      
      def initialize
        @channel = Default[:channel]
        @velocity = Default[:velocity]
      end

      # create a control change message
      def control_change(id, value, opts = {})
        props = message_properties(opts, :channel)
        id.kind_of?(Numeric) ? ControlChange.new(props[:channel], id, value) : ControlChange[id].new(props[:channel], value)
      end
      alias_method :cc, :control_change
      alias_method :c, :control_change

      # create a note message
      def note(id, opts = {})
        props = message_properties(opts, :channel, :velocity)
        note = id.kind_of?(Numeric) ? NoteOn.new(props[:channel], id, props[:velocity]) : NoteOn[id].new(props[:channel], props[:velocity])
        @last_note = note
        note
      end
      alias_method :n, :note

      # create a note off message
      def note_off(id, opts = {})
        props = message_properties(opts, :channel, :velocity)
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
        props = message_properties(opts, :channel)
        MIDIMessage::ProgramChange.new(props[:channel], program)
      end
      alias_method :pc, :program_change

      # create a note-off message from the last note-on message
      def off
        o = @last_note.to_note_off
        @last_note = nil
        o
      end
      alias_method :o, :off

      # sets the default channel for the current block
      def channel(val = nil)
        val.nil? ? @channel : @channel = val
      end
      alias_method :ch, :channel

      # sets the default velocity for the current block
      def velocity(val = nil)
        val.nil? ? @velocity : @velocity = val
      end
      alias_method :vel, :velocity
      alias_method :v, :velocity

      private

      def message_properties(opts, *props)
        output = {}
        props.each do |prop|
          output[prop] = opts[prop]
          self.send("#{prop.to_s}=", output[prop]) if self.send(prop.to_s).nil?
          output[prop] ||= self.send(prop.to_s)
        end
        output
      end

    end

  end

end