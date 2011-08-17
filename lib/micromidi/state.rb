#!/usr/bin/env ruby
#
module MicroMIDI

  class State
    
    Default = {
      :channel => 0,
      :velocity => 100
    }
    
    attr_accessor :channel,
                  :last_note,
                  :super_sticky, 
                  :velocity
    
    attr_reader :inputs,
                :listeners,
                :outputs,
                :output_cache, 
                :start_time
        
    def initialize(ins, outs, options = {})
      @last_note = nil    
      @listeners = []
      @output_cache = []
      @start_time = Time.now.to_f
      @super_sticky = false

      @channel = options[:channel] || Default[:channel]
      @velocity = options[:velocity] || Default[:velocity]  
      
      @inputs = ins
      @outputs = outs  
    end
    
    def record(outp)
      @output_cache << { :message => outp, :timestamp => now }      
    end
    
    def toggle_super_sticky
      @super_sticky = !@super_sticky
    end

    def message_properties(opts, *props)
      output = {}
      props.each do |prop|
        output[prop] = opts[prop]
        self.send("#{prop.to_s}=", output[prop]) if self.send(prop).nil? && @super_sticky
        output[prop] ||= self.send(prop.to_s)
      end
      output
    end
    
    private
    
    def now
      ((Time.now.to_f - @start_time) * 1000)
    end

  end

end