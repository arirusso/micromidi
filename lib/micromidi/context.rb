#!/usr/bin/env ruby
#

module MicroMIDI
  
  class Context
    
    include Instructions::Composite
            
    def initialize(ins, outs, &block)
      
      @state = State.new(ins, outs)
      
      @input = Instructions::Input.new(@state)      
      @message = Instructions::Message.new(@state)
      @output = Instructions::Output.new(@state)
      @sticky = Instructions::Sticky.new(@state)
      
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
      @state.record(outp)
      delegated ? outp : super
    end
        
  end
end