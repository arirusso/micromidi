#!/usr/bin/env ruby
#

module MicroMIDI
  
  Default = {
    :channel => 0,
    :velocity => 100
  }
  
  class Context
    
    extend Forwardable
    
    attr_reader :output_cache
    
    def_delegators :@output, 
                   :channel,
                   :velocity
        
    def initialize(ins, outs, &block)      
      @output_cache = []
      @start_time = Time.now.to_f
      
      @input = Instructions::Input.new(ins)      
      @message = Instructions::Message.new
      @output = Instructions::Output.new(outs)
      
      self.instance_eval(&block)
    end
    
    def play(n, duration)
      msg = @message.note(n)
      @output_cache << { :message => @output.output(msg), :timestamp => now }
      sleep(duration)
      @output_cache << { :message => @message.off, :timestamp => now }
      msg
    end
    
    def method_missing(m, *a, &b)
      delegated = false
      outp = nil
      if @message.respond_to?(m)
        @output.output(@message.send(m, *a, &b))
        delegated = true
      else
        [@input, @output].each do |dsl| 
          if dsl.respond_to?(m)
            outp = dsl.send(m, *a, &b)
            delegated = true
          end
        end
      end
      @output_cache << { :message => outp, :timestamp => now }
      delegated ? outp : super
    end
    
    private
    
    def now
      ((Time.now.to_f - @start_time) * 1000)
    end
    
  end
end