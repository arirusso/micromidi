#!/usr/bin/env ruby
#
module MicroMIDI

  module Instructions
    
    class SysEx

      include MIDIMessage
      
      def initialize(state)
        @state = state
      end
      
      # create a sysex command
      def sysex_command(address, data, options = {})
        options[:sysex_node] ||= options[:node]
        props = @state.message_properties(options, :sysex_node)
        SystemExclusive::Command.new(address, data, :node => props[:sysex_node])
      end
      alias_method :command, :sysex_command
      
      # create a sysex request
      def sysex_request(address, size, options = {})
        options[:sysex_node] ||= options[:node]
        props = @state.message_properties(options, :sysex_node)
        SystemExclusive::Request.new(address, size, :node => props[:sysex_node])        
      end
      alias_method :request, :sysex_request
      
      # create an indeterminate sysex message
      def sysex_message(data, options = {})
        options[:sysex_node] ||= options[:node]
        props = @state.message_properties(options, :sysex_node)
        SystemExclusive::Message.new(data, :node => props[:sysex_node])
      end
      alias_method :sysex, :sysex_message

    end

  end

end