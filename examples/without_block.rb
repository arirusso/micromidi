#!/usr/bin/env ruby
$:.unshift File.join( File.dirname( __FILE__ ), '../lib')

require "micromidi"

# this example demonstrates using MicroMIDI without a block
# this allows you to use it as a more conventional Ruby library

@o = UniMIDI::Output.use(:first)

midi = MIDI::IO.new(@o)

midi.note("C")
midi.off 

midi.cc(5, 120)

midi.play("C3", 0.5)
