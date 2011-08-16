#!/usr/bin/env ruby
#
module MicroMIDI

  module Instructions
    
    class Output
      
      def initialize(outs)
        @outputs = outs
      end

      def output(msg)
        @outputs.each { |o| o.puts(msg) }
        msg
      end

    end

  end

end