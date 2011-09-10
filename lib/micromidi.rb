#!/usr/bin/env ruby
#
# micromidi
# A Ruby DSL for MIDI
#
# (c)2011 Ari Russo 
# licensed under the Apache 2.0 License
#

# libs
require 'midi-eye'
require 'midi-message'
require 'unimidi'

module MicroMIDI
  
  VERSION = "0.0.5"
  
  module Instructions
  end
  
  def self.new(*a, &block)
    message(*a, &block)
  end
  
  def self.message(*args, &block)
    ins, outs = *process_devices(args)
    MicroMIDI::Context.new(ins, outs, &block)
  end
  class << self
    alias_method :io, :message
    alias_method :using, :message
  end
  
  private
  
  def self.process_devices(args)
    ins = args.find_all { |d| d.respond_to?(:type) && d.type == :input && d.respond_to?(:gets) }
    outs = args.find_all { |d| d.respond_to?(:puts) }
    [ins, outs]    
  end  
  
end
MIDI = MicroMIDI

# modules
require 'micromidi/instructions/composite'

# classes
require 'micromidi/context'
require 'micromidi/state'
require 'micromidi/instructions/process'
require 'micromidi/instructions/input'
require 'micromidi/instructions/message'
require 'micromidi/instructions/output'
require 'micromidi/instructions/sticky'
require 'micromidi/instructions/sysex'

# re-open
require 'micromidi/instructions/shorthand'