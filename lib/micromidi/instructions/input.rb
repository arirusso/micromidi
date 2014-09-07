module MicroMIDI

  module Instructions
    
    class Input
   
      def initialize(state)
        @state = state
      end

      # bind an event that will be called every time a message is received
      def receive(*args, &block)
        message_options = args.dup
        options = message_options.last.kind_of?(Hash) ? message_options.pop : {}
        unless message_options.empty?
          match = { :class => message_classes(message_options) }
        end
        listener(match, options) do |event| 
          yield(event[:message], event[:timestamp])
        end
      end
      alias_method :gets, :receive
      alias_method :handle, :receive
      alias_method :listen, :receive
      alias_method :listen_for, :receive
      alias_method :when_receive, :receive

      def receive_unless(*args, &block)
        message_options = args.dup
        options = message_options.last.kind_of?(Hash) ? message_options.pop : {}
        match = message_classes(message_options)
        listener(nil, options) do |event| 
          yield(event[:message], event[:timestamp]) unless match.include?(event[:message].class)
        end
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
      def thru_if(*args)
        receive_options = thru_options(args)
        receive(*receive_options) { |message, timestamp| output(message) }
      end

      # send input messages thru to the outputs unless of a specific class
      def thru_unless(*args)
        receive_options = thru_options(args)
        receive_unless(*receive_options) { |message, timestamp| output(message) }
      end
      
      # like <em>thru_unless</em> except a block can be passed that will be called when
      # notes specified as the <em>unless</em> arrive
      def thru_except(*args, &block)
        thru_unless(*args)
        receive(*args, &block)        
      end
            
      # wait for input on the last input passed in
      # can pass the option :from => [an input] to specify which one to wait on
      def wait_for_input(options = {})
        listener = options[:from] || @state.listeners.last || @state.thru_listeners.last
        listener.join
      end
      
      def join
        loop { wait_for_input }
      end

      protected

      def listener(match, options = {}, &block)
        inputs = options[:from] || @state.inputs
        do_thru = options.fetch(:thru, false)
        should_start = options.fetch(:start, true)
        match ||= {}

        listeners = inputs.map { |input| initialize_listener(input, match, do_thru, &block) }
        if should_start
          listeners.each { |listener| listener.start(:background => true) }
        end
      end

      private

      def initialize_listener(input, match, do_thru, &block)
        listener = MIDIEye::Listener.new(input)
        listener.listen_for(match, &block)
        if do_thru
          @state.thru_listeners.each(&:stop)
          @state.thru_listeners.clear
          @state.thru_listeners << listener
        else 
          @state.listeners << listener
        end 
        listener
      end

      # The options for using thru
      def thru_options(args)
        receive_options = args.dup
        if receive_options.last.kind_of?(Hash)
          receive_options.last[:thru] = true
        else
          receive_options << { :thru => true }
        end
        receive_options
      end

      def message_classes(list)
        list.map do |type|
          case type
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
        end.flatten.compact
      end

    end

  end

end
