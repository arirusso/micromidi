#!/usr/bin/env ruby

module MIDIDSL
  
  VERSION = "0.0.1"
  
end

module MIDI

  def self.message(&block)
    MIDIDSL::Context.new(&block)
  end  
  
end

#require 'forwardable'
require 'midi-message'

require 'midi-dsl/context'

