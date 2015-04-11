#!/usr/bin/env ruby
$:.unshift(File.join("..", "lib"))

require "micromidi"

# Demonstrates super-sticky mode

output = UniMIDI::Output.use(0)

MIDI.using(@o) do

  super_sticky

  channel 1

  note "C4"
  off

  octave 5
  velocity 60

  note "E", :channel => 2
  off

  note "C3"
  off

end
