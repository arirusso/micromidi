#!/usr/bin/env ruby
#

module MIDIMessenger
  
  Default = {
    :channel => 0,
    :velocity => 100
  }
  
  class Context
    
    attr_accessor :channel,
                  :velocity
        
    def initialize(ins, outs, &block)
      @channel = Default[:channel]
      @velocity = Default[:velocity]
      self.instance_eval(&block)
    end
    
    def note(name, opts = {})
      props = message_properties(opts, :channel, :velocity)
      note = MIDIMessage::NoteOn[name].new(props[:channel], props[:velocity])      
      @last_note = note 
      note
    end
    
    # 
    def play(note, duration)
      sleep duration
      off
      note
    end
    
    # turn the last note off
    def off
      off = @last_note.to_note_off
      @last_note = nil
      off
    end
    
    def control_change(name, value, opts = {})
    end
    alias_method :cc, :control_change
    
    def channel(val = nil)
      val.nil? ? @channel : @channel = val
    end

    def velocity(val = nil)
      val.nil? ? @velocity : @velocity = val
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