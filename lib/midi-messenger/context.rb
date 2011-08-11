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
      @input.send(m, *a, &b) and return if @input.respond_to?(m)
      @output.send(m, *a, &b) and return if @output.respond_to?(m)
      super
    end
    
  end
end