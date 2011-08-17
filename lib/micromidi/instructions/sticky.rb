#!/usr/bin/env ruby
#
module MicroMIDI

  module Instructions
    
    class Sticky

      # sets the sticky channel for the current block
      def channel(state, val = nil)
        val.nil? ? state.channel : state.channel = val
      end
      alias_method :ch, :channel

      # sets the sticky velocity for the current block
      def velocity(state, val = nil)
        val.nil? ? state.velocity : state.velocity = val
      end
      alias_method :vel, :velocity
      alias_method :v, :velocity

    end

  end

end