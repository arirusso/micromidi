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
        a.unshift(@state)
        outp = @output.output(@message.send(m, *a, &b))
        delegated = true
      elsif @sticky.respond_to?(m)
        a.unshift(@state)
        @sticky.send(m, *a, &b)
        delegated = true
      else
        [@input, @output].each do |dsl| 
          if dsl.respond_to?(m)
            outp = dsl.send(m, *a, &b)
            delegated = true
          end
        end
      end
      @state.output_cache << { :message => outp, :timestamp => @state.now }
      delegated ? outp : super
    end
    
    private
        
  end
end