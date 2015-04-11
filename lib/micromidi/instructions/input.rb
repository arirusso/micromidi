module MicroMIDI

  module Instructions

    # Commands dealing with MIDI input
    class Input

      # @param [State] state
      # @param [Proc] thru_action Output module to send thru messages to
      def initialize(state, &thru_action)
        @state = state
        @thru_action = thru_action
      end

      # Bind an event that will be fired when a message is received
      # @param [*Object] args Types of messages to filter on eg :note_on, :control_change
      # @param [Proc] callback The event callback
      # @return [Boolean]
      def receive(*args, &callback)
        args = args.dup
        options = args.last.kind_of?(Hash) ? args.pop : {}
        unless args.empty?
          match = { :class => message_classes(args) }
        end
        listener(match, options) do |event|
          yield(event[:message], event[:timestamp])
        end
        true
      end
      alias_method :gets, :receive
      alias_method :handle, :receive
      alias_method :listen, :receive
      alias_method :listen_for, :receive
      alias_method :when_receive, :receive

      # Bind an event that will be fired when a message is received
      # @param [*Object] args Types of messages to filter out eg :note_on, :control_change
      # @param [Proc] callback The event callback
      # @return [Boolean]
      def receive_unless(*args, &callback)
        args = args.dup
        options = args.last.kind_of?(Hash) ? args.pop : {}
        match = message_classes(args)
        listener(nil, options) do |event|
          yield(event[:message], event[:timestamp]) unless match.include?(event[:message].class)
        end
      end
      alias_method :handle_unless, :receive_unless
      alias_method :listen_unless, :receive_unless
      alias_method :listen_for_unless, :receive_unless
      alias_method :unless_receive, :receive_unless

      # Send input messages thru to the outputs
      def thru
        thru_if
      end

      # Send input messages thru to the outputs if they have a specified class
      # @param [*Object] args
      # @return [Boolean]
      def thru_if(*args)
        receive_options = thru_arguments(args)
        receive(*receive_options) { |message, timestamp| @thru_action.call(message) }
        true
      end

      # Send input messages thru to the outputs unless they're of the specified class
      # @param [*Object] args
      # @return [Boolean]
      def thru_unless(*args)
        receive_options = thru_arguments(args)
        receive_unless(*receive_options) { |message, timestamp| @thru_action.call(message) }
      end

      # Similar to Input#thru_unless except a callback can be passed that will be fired when notes specified arrive
      # @param [*Object] args
      # @param [Proc] callback
      # @return [Boolean]
      def thru_except(*args, &callback)
        thru_unless(*args)
        receive(*args, &callback)
      end

      # Wait for input on the last input passed in (blocking)
      # Can pass the option :from => [an input] to specify which one to wait on
      # @param [Hash] options
      # @option options [UniMIDI::Input] :from
      # @return [Boolean]
      def wait_for_input(options = {})
        listener = options[:from] || @state.listeners.last || @state.thru_listeners.last
        listener.join
        true
      end

      # Join the listener thread
      # @return [Boolean]
      def join
        loop { wait_for_input }
        true
      end

      protected

      # Initialize input event listeners for the given inputs and options
      # @param [Hash] match
      # @param [Hash] options
      # option options [Array<UniMIDI::Input>, UniMIDI::Input] :from
      # option options [Boolean] :start
      # option options [Boolean] :thru
      def listener(match, options = {}, &block)
        inputs = options[:from] || @state.inputs
        inputs = [inputs].flatten
        do_thru = options.fetch(:thru, false)
        should_start = options.fetch(:start, true)
        match ||= {}

        listeners = inputs.map { |input| initialize_listener(input, match, do_thru, &block) }
        if should_start
          listeners.each { |listener| listener.start(:background => true) }
        end
      end

      private

      # Initialize an input event listener
      # @param [UniMIDI::Input] input
      # @param [Hash] match
      # @param [Boolean] do_thru
      # @param [Proc] callback
      # @return [MIDIEye::Listener]
      def initialize_listener(input, match, do_thru, &callback)
        listener = MIDIEye::Listener.new(input)
        listener.listen_for(match, &callback)
        if do_thru
          @state.thru_listeners.each(&:stop)
          @state.thru_listeners.clear
          @state.thru_listeners << listener
        else
          @state.listeners << listener
        end
        listener
      end

      # The arguments for using thru
      # @param [Array<Object>] args
      # @return [Array<Object, Hash>]
      def thru_arguments(args)
        receive_options = args.dup
        if receive_options.last.kind_of?(Hash)
          receive_options.last[:thru] = true
        else
          receive_options << { :thru => true }
        end
        receive_options
      end

      # Get the MIDIMessage class for the given note name
      # @param [Array<String, Symbol>] type_list
      # @return [Array<Class>]
      def message_classes(type_list)
        classes = type_list.map do |type|
          case type.to_sym
          when :aftertouch, :pressure, :aft then [MIDIMessage::ChannelAftertouch, MIDIMessage::PolyphonicAftertouch]
          when :channel_aftertouch, :channel_pressure, :ca, :cp then MIDIMessage::ChannelAftertouch
          when :control_change, :cc, :c then MIDIMessage::ControlChange
          when :note, :n then [MIDIMessage::NoteOn, MIDIMessage::NoteOff]
          when :note_on, :nn then MIDIMessage::NoteOn
          when :note_off, :no, :off then MIDIMessage::NoteOff
          when :pitch_bend, :pb then MIDIMessage::PitchBend
          when :polyphonic_aftertouch, :poly_aftertouch, :poly_pressure, :polyphonic_pressure, :pa, :pp then MIDIMessage::PolyphonicAftertouch
          when :program_change, :pc, :p then MIDIMessage::ProgramChange
          end
        end
        classes.flatten.compact
      end

    end

  end

end
