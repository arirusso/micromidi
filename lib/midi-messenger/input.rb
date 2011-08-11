#!/usr/bin/env ruby
#
module MIDIMessenger
  
  module Input
    
    def receive(*a, &block)
      inputs = nil
      if a.last.kind_of?(Hash)
        options = a.last
        inputs = options[:from]
      end
      match = a.empty? ? nil : { :class => msg_classes(a) }
      listener(match, :from => inputs) { |event| yield(event[:message], event[:timestamp]) }      
    end
    
    def receive_unless(*a, &block)
      match = { :class => msg_classes(a) }
      listener { |event| yield(event[:message], event[:timestamp]) unless match.include?(event[:message].class) }            
    end
    
    # send input messages thru to the outputs
    def thru
      thru_if
    end
    
    # send input messages thru to the outputs if it has a specific class
    def thru_if(*a)
      receive(*a) { |message, timestamp| output(message) }
    end
    
    # send input messages thru to the outputs unless of a specific class
    def thru_unless(*a)
      receive_unless(*a) { |message, timestamp| output(message) }
    end
  
    def wait_for_input(options = {})
      listener = options[:from] || @listeners.last
      @listeners.each { |l| l.start }
      listener.join
    end

    protected 

    def listener(match = {}, options = {}, &block)
      inputs = options[:from] || @inputs
      inputs.each do |input|
        listener = MIDIEye::Listener.new(input)
        listener.listen_for(match, &block)
        @listeners << listener
      end
    end
    
    private
    
    def initialize_input(ins)
      @inputs = ins
      @listeners = []
    end

  end
  
end