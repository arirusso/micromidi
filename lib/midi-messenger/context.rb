#!/usr/bin/env ruby
#

module MIDIMessenger
  
  class Context
        
    def initialize(&block)
      self.instance_eval(&block)
    end
    
    def note(name, opts = {})
      props = message_properties(opts, :channel, :velocity)      
      MIDIMessage::NoteOn[name].new(props[:channel], props[:velocity])
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