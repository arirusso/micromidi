#!/usr/bin/env ruby
#

module MIDIMessenger
  
  Default = {
    :channel => 0,
    :velocity => 100
  }
  
  class Context
    
    include MIDIMessage
    
    attr_accessor :channel,
                  :velocity
        
    def initialize(ins, outs, &block)
      @inputs = ins
      @outputs = outs
      @channel = Default[:channel]
      @velocity = Default[:velocity]
      @listeners = []
      
      self.instance_eval(&block)
    end
    
    def receive(*a, &block)
      match = a.empty? ? nil : { :class => msg_classes(a) }
      listener(match) { |event| yield(event[:message], event[:timestamp]) }      
    end
    
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
    
    # create a control change message
    def control_change(id, value, opts = {})
      props = message_properties(opts, :channel)
      cc = if id.kind_of?(Numeric)
        ControlChange.new(props[:channel], id, value)
      else
        ControlChange[id].new(props[:channel], value)
      end
      output_or_return(cc)       
    end
    alias_method :cc, :control_change
    alias_method :c, :control_change
        
    # create a note message
    def note(id, opts = {})
      props = message_properties(opts, :channel, :velocity)
      note = if id.kind_of?(Numeric)
          NoteOn.new(props[:channel], id, props[:velocity])
        else
          NoteOn[id].new(props[:channel], props[:velocity])
      end      
      @last_note = note 
      output_or_return(note)
    end
    alias_method :n, :note
    
    # create a note off message
    def note_off(id, opts = {})
      props = message_properties(opts, :channel, :velocity)
      off = if id.kind_of?(Numeric)
        NoteOff.new(props[:channel], id, props[:velocity])
      else
        NoteOff[id].new(props[:channel], props[:velocity])
      end   
      output_or_return(off)
    end
    alias_method :no, :note_off
    
    # create a MIDI message from a byte string, array of bytes, or list of bytes
    def parse(message)
      output_or_return(MIDIMessage.parse(message))
    end
    alias_method :p, :parse
    
    # create a program change message
    def program_change(program, opts = {})
      props = message_properties(opts, :channel)
      output_or_return(MIDIMessage::ProgramChange.new(props[:channel], program))
    end
    alias_method :pc, :program_change
     
    def play(note, duration)
      output(note)
      sleep(duration)
      off
      note
    end
    
    # create a note-off message from the last note-on message
    def off
      off = @last_note.to_note_off
      @last_note = nil
      output_or_return(off)
    end
    alias_method :o, :off
        
    def channel(val = nil)
      val.nil? ? @channel : @channel = val
    end

    def velocity(val = nil)
      val.nil? ? @velocity : @velocity = val
    end
    
    def output(msg)
      @outputs.each { |o| o.puts(msg) }
      msg
    end
    
    def wait_for_input(options = {})
      listener = options[:from] || @listeners.last
      @listeners.each { |l| l.start }
      listener.join
    end
    
    protected
    
    def listener(match = {}, &block)
      @inputs.each do |input|
        listener = MIDIEye::Listener.new(input)
        listener.listen_for(match, &block)
        @listeners << listener
      end
    end
    
    def output_or_return(msg)
      output(msg) unless @outputs.empty?
      msg
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