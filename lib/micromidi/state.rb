#!/usr/bin/env ruby
#
module MicroMIDI

  class State
    
    Default = {
      :channel => 0,
      :octave => 2,
      :velocity => 100
    }
    
    attr_accessor :auto_output,
                  :channel,
                  :last_note,
                  :octave,
                  :sysex_node,
                  :super_sticky, 
                  :velocity
    
    attr_reader :inputs,
                :last_command,
                :listeners,
                :outputs,
                :output_cache, 
                :start_time,
                :thru_listeners
        
    def initialize(ins, outs, options = {})
      @auto_output = true
      @last_command = nil
      @last_note = nil    
      @listeners = []
      @thru_listeners = []
      @output_cache = []
      @start_time = Time.now.to_f
      @super_sticky = false

      @channel = options[:channel] || Default[:channel]
      @velocity = options[:velocity] || Default[:velocity]
      @octave = options[:octave] || Default[:octave]  
      
      @inputs = ins
      @outputs = outs  
    end
    
    def record(m, a, b, outp)
      ts = now
      @output_cache << { :message => outp, :timestamp => ts }
      @last_command = { :method => m, :args => a, :block => b, :timestamp => ts }
    end
    
    def toggle_super_sticky
      @super_sticky = !@super_sticky
    end
    
    def toggle_auto_output
      @auto_output = !@auto_output
    end

    def message_properties(opts, *props)
      output = {}
      props.each do |prop|
        output[prop] = opts[prop]
        self.send("#{prop.to_s}=", output[prop]) if !output[prop].nil? && (self.send(prop).nil? || @super_sticky)
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