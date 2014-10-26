module MicroMIDI

  module Instructions

    module Composite

      #
      # Play a note or notes, for the given duration.
      #
      # The first argument must be: [Array<String>, Array<MIDIMessage::NoteOn>, String, MIDIMessage::NoteOn]
      # The last argument must be [Numeric] representing the duration
      #
      # Additional arguments can be [Array<String>, Array<MIDIMessage::NoteOn>, String, MIDIMessage::NoteOn] and will
      # be played as a chord simultaneously with the first argument.
      #
      # @param [*Object] args
      # @return [Array<MIDIMessage::NoteOn>, MIDIMessage::NoteOn]
      def play(*args)
        raise "Last argument must be a Numeric duration" unless args.last.kind_of?(Numeric)
        args = args.dup
        duration = args.pop
        note_or_notes = [args].flatten
        messages = as_note_messages(note_or_notes)
        sleep(duration)
        send_note_offs(messages)

        messages.count > 1 ? messages : messages.first
      end

      # Send a note off message for every note on every channel
      # @return [Boolean]
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

      # Send note off messages for the given note messages
      # @param [Array<MIDIMessage::NoteOn, MIDIMessage::NoteOff>] messages
      # @return [Boolean]
      def send_note_offs(messages)
        messages.each do |message|
          note_off(message.note, :channel => message.channel, :velocity => message.velocity)
        end
        true
      end

      # MIDI note message objects for the given arguments
      # @param [Array<MIDIMessage::NoteOn, MIDIMessage::NoteOff, Fixnum, String>] note_or_notes
      # @return [Array<MIDIMessage::NoteOn>]
      def as_note_messages(note_or_notes)
        note_or_notes.map do |item|
          case item
          when Fixnum, String then note(item)
          when MIDIMessage then item
          end
        end
      end

    end

  end

end
