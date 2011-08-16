#!/usr/bin/env ruby
#
module MicroMIDI

  module Instructions
    
    class Sticky
      
      def initialize

      end

      # sets the sticky channel for the current block
      def channel(val = nil)
        val.nil? ? @channel : @channel = val
      end
      alias_method :ch, :channel

      # sets the sticky velocity for the current block
      def velocity(val = nil)
        val.nil? ? @velocity : @velocity = val
      end
      alias_method :vel, :velocity
      alias_method :v, :velocity

    end

  end

end