#!/usr/bin/env ruby
#
module MicroMIDI

  module Instructions
    
    module Composite
      
      def play(n, duration)
        msg = @message.note(n)
        @state.record(@output.output(msg))
        sleep(duration)
        @state.record(@message.off)
        msg
      end
      
    end

  end

end
