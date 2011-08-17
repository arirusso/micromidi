#!/usr/bin/env ruby
#
module MicroMIDI

  module Instructions
    
    class Output
      
      def initialize(state)
        @state = state
      end

      def output(msg)
        @state.outputs.each { |o| o.puts(msg) }
        msg
      end

    end

  end

end