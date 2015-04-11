#!/usr/bin/env ruby
$:.unshift(File.join("..", "lib"))

require "micromidi"

# Demonstrates using MicroMIDI without the command block/ DSL

@o = UniMIDI::Output.gets

midi = MIDI::IO.new(@o)

midi.note("C")
midi.off

midi.cc(5, 120)

midi.play("C3", 0.5)
