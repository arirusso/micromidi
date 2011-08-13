#!/usr/bin/env ruby
#

module MIDIMessenger
  
  Default = {
    :channel => 0,
    :velocity => 100
  }
  
  class Context
    
    extend Forwardable
    
    def_delegators :@output, 
                   :channel,
                   :velocity
        
    def initialize(ins, outs, &block)
      
      @input = InputDSL.new(ins)
      @output = OutputDSL.new(outs)
      
      self.instance_eval(&block)
    end
    
    def method_missing(m, *a, &b)
      delegated = false
      outp = nil
      [@input, @output].each do |dsl| 
        if dsl.respond_to?(m)
          outp = dsl.send(m, *a, &b)
          delegated = true
        end
      end 
      delegated ? outp : super
    end
    
  end
end