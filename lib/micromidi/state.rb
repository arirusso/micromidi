#!/usr/bin/env ruby
#
module MicroMIDI

  class State
    
    Default = {
      :channel => 0,
      :velocity => 100
    }
    
    attr_accessor :channel, 
                  :velocity
    
    attr_reader :output_cache, 
                :start_time
        
    def initialize(options = {})
      @channel = options[:channel] || Default[:channel]
      @velocity = options[:velocity] || Default[:velocity]      
      @output_cache = []
      @start_time = Time.now.to_f
    end

    def message_properties(opts, *props)
      output = {}
      props.each do |prop|
        output[prop] = opts[prop]
        #self.send("@#{prop.to_s}=", output[prop]) if self.send(prop).nil?
        output[prop] ||= self.send(prop.to_s)
      end
      output
    end
    
    def now
      ((Time.now.to_f - @start_time) * 1000)
    end

  end

end