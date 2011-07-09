#!/usr/bin/env ruby

require 'midi-message'

module MIDIMessenger
  
  VERSION = "0.0.1"
  
end

module MIDI

  def self.message(*ios, &block)
    MIDIMessenger::Context.new(&block)
  end  
  
end

#require 'forwardable'

require 'midi-messenger/context'

