#!/usr/bin/env ruby
#

module MIDIMessenger
  
  Default = {
    :channel => 0,
    :velocity => 100
  }
  
  class Context
   
    include Input
    include Output
    
    attr_accessor :channel,
                  :velocity
        
    def initialize(ins, outs, &block)
      
      initialize_input(ins)
      initialize_output(outs)
      
      self.instance_eval(&block)
    end       
    
  end
end