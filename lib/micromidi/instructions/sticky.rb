#!/usr/bin/env ruby
#
module MicroMIDI

  module Instructions
    
    class Sticky
      
      def initialize(state)
        @state = state
      end

      # sets the sticky channel for the current block
      def channel(val = nil)
        val.nil? ? @state.channel : @state.channel = val
      end
      alias_method :ch, :channel

      # sets the sticky velocity for the current block
      def velocity(val = nil)
        val.nil? ? @state.velocity : @state.velocity = val
      end
      alias_method :vel, :velocity
      alias_method :v, :velocity
      
      def super_sticky
        @state.toggle_super_sticky
      end
      
    end

  end

end