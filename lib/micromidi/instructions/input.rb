#!/usr/bin/env ruby
#
module MicroMIDI

  module Instructions
    
    class Input

      include MIDIMessage
      
      def initialize(state)
        @state = state
      end

      # bind an event that will be called every time a message is received
      def receive(*a, &block)
        inputs = nil
        if a.last.kind_of?(Hash)
          options = a.last
          inputs = options[:from]
        end
        match = a.empty? ? nil : { :class => msg_classes(a) }
        listener(match, :from => inputs) { |event| yield(event[:message], event[:timestamp]) }
      end
      alias_method :handle, :receive
      alias_method :listen, :receive
      alias_method :listen_for, :receive
      alias_method :when_receive, :receive

      def receive_unless(*a, &block)
        match = { :class => msg_classes(a) }
        listener { |event| yield(event[:message], event[:timestamp]) unless match.include?(event[:message].class) }
      end
      alias_method :handle_unless, :receive_unless
      alias_method :listen_unless, :receive_unless
      alias_method :listen_for_unless, :receive_unless
      alias_method :unless_receive, :receive_unless

      # send input messages thru to the outputs
      def thru
        thru_if
      end

      # send input messages thru to the outputs if it has a specific class
      def thru_if(*a)
        receive(*a) { |message, timestamp| output(message) }
      end

      # send input messages thru to the outputs unless of a specific class
      def thru_unless(*a)
        receive_unless(*a) { |message, timestamp| output(message) }
      end
      
      # wait for input on the last input passed in
      # can pass the option :from => [an input] to specify which one to wait on
      def wait_for_input(options = {})
        l = options[:from] || @state.listeners.last
        l.join
      end

      protected

      def listener(match = {}, options = {}, &block)
        inputs = options[:from] || @state.inputs
        inputs.each do |input|
          listener = MIDIEye::Listener.new(input)
          listener.listen_for(match, &block)
          @state.listeners << listener
          listener.start unless !options[:start].nil? && !options[:start]
        end
      end

      private

      def msg_classes(list)
        list.map do |type|
          case type
          when :aftertouch, :pressure then [ChannelAftertouch, PolyphonicAftertouch]
          when :channel_aftertouch, :channel_pressure, :ca, :cp then ChannelAftertouch
          when :control_change, :cc then ControlChange
          when :note then [NoteOn, NoteOff]
          when :note_on, :n then NoteOn
          when :note_off, :no then NoteOff
          when :pitch_bend, :pb then PitchBend
          when :polyphonic_aftertouch, :poly_aftertouch, :poly_pressure, :polyphonic_pressure, :pa, :pp then PolyphonicAftertouch
          when :program_change, :pc then ProgramChange
          end
        end.flatten.compact
      end

    end

  end

end