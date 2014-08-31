#
# micromidi
#
# A Ruby DSL for MIDI
#
# (c)2011-2014 Ari Russo 
# licensed under the Apache 2.0 License
#

# libs
require "forwardable"
require "midi-eye"
require "midi-message"
require "unimidi"

module MicroMIDI
  
  VERSION = "0.0.9"
  
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
    alias_method :using, :message
  end
  
  module IO
    
    def self.new(*args, &block)
      MicroMIDI.message(*args, &block)
    end
    
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
require "micromidi/instructions/composite"

# classes
require "micromidi/context"
require "micromidi/state"
require "micromidi/instructions/process"
require "micromidi/instructions/input"
require "micromidi/instructions/message"
require "micromidi/instructions/output"
require "micromidi/instructions/sticky"
require "micromidi/instructions/sysex"

# extension
require "micromidi/instructions/shorthand"
