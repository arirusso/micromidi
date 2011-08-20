#!/usr/bin/env ruby
#

module MicroMIDI
  
  class Context
    
    include Instructions::Composite
            
    def initialize(ins, outs, &block)
      
      @state = State.new(ins, outs)
      
      @instructions = {
        :effect => Instructions::Effect.new(@state)
        :input => Instructions::Input.new(@state),      
        :message => Instructions::Message.new(@state),
        :output => Instructions::Output.new(@state),
        :sticky => Instructions::Sticky.new(@state)
      }
       
      instance_eval(&block)
    end
    
    def repeat
      self.send(@state.last_command[:method], *@state.last_command[:args]) unless @state.last_command.nil?
    end
    
    def method_missing(m, *a, &b)
      delegated = false
      outp = nil
      if @instructions[:message].respond_to?(m)
        outp = @instructions[:output].output(@instructions[:message].send(m, *a, &b))
        delegated = true
      else
        [@instructions[:effect], @instructions[:input], @instructions[:output], @instructions[:sticky]].each do |dsl| 
          if dsl.respond_to?(m)
            outp = dsl.send(m, *a, &b)
            delegated = true
          end
        end
      end
      @state.record(m, a, b, outp)
      delegated ? outp : super
    end
        
  end
end