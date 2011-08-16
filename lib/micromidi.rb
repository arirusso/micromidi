#!/usr/bin/env ruby

require 'forwardable'

require 'midi-eye'
require 'midi-message'
require 'unimidi'

module MicroMIDI
  
  VERSION = "0.0.1"
  
  module Instructions
  end
  
end

module MIDI
  
  def self.process_devices(args)
    ins = args.find_all { |device| device.direction == :input }
    outs = args.find_all { |device| device.direction == :output }
    [ins, outs]    
  end
  
  def self.message(*args, &block)
    ins, outs = *process_devices(args)
    MicroMIDI::Context.new(ins, outs, &block)
  end  
  
end

# classes
require 'micromidi/input'
require 'micromidi/context'
require 'micromidi/message'
require 'micromidi/output'
