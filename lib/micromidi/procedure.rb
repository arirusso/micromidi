#!/usr/bin/env ruby
#
module MicroMIDI

  module Instructions
    
    class Procedures
      
      def play(n, duration)
        msg = @message.note(n)
        @output_cache << { :message => @output.output(msg), :timestamp => now }
        sleep(duration)
        @output_cache << { :message => @message.off, :timestamp => now }
        msg
      end
      
    end

  end

end
