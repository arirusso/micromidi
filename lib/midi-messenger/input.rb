#!/usr/bin/env ruby
#
module MIDIMessenger
  
  class InputDSL
    
    include MIDIMessage

    def initialize(ins)
      @inputs = ins
      @listeners = []
    end

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
    
    def receive_unless(*a, &block)
      match = { :class => msg_classes(a) }
      listener { |event| yield(event[:message], event[:timestamp]) unless match.include?(event[:message].class) }            
    end
    
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
  
    def wait_for_input(options = {})
      listener = options[:from] || @listeners.last
      @listeners.each { |l| l.start }
      listener.join
    end

    protected 

    def listener(match = {}, options = {}, &block)
      inputs = options[:from] || @inputs
      inputs.each do |input|
        listener = MIDIEye::Listener.new(input)
        listener.listen_for(match, &block)
        @listeners << listener
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