#!/usr/bin/env ruby
#
module MIDIMessenger
  
  class OutputDSL
    
    include MIDIMessage
    
    def initialize(outs)
      @outputs = outs
      @channel = Default[:channel]
      @velocity = Default[:velocity]
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
     
    def play(n, duration)
      msg = note(n)
      output_or_return(msg)
      sleep(duration)
      off
      msg
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
        
    protected
        
    def output_or_return(msg)
      output(msg) unless @outputs.empty?
      msg
    end
            
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