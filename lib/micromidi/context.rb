#!/usr/bin/env ruby
#

module MicroMIDI
  
  class Context
    
    include Instructions::Composite
            
    def initialize(ins, outs, &block)
      
      @state = State.new
      
      @input = Instructions::Input.new(ins)      
      @message = Instructions::Message.new
      @output = Instructions::Output.new(outs)
      @sticky = Instructions::Sticky.new
      
      self.instance_eval(&block)
    end
    
    def method_missing(m, *a, &b)
      delegated = false
      outp = nil
      if @message.respond_to?(m)
        outp = @output.output(@message.send(m, *a, &b))
        delegated = true
      else
        [@input, @output, @sticky].each do |dsl| 
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