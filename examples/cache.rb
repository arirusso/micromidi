#!/usr/bin/env ruby
$:.unshift(File.join("..", "lib"))

require "micromidi"

# This example demonstrates printing the command cache

output = UniMIDI::Output.gets

MIDI.using(output) do
  note "C4"
  cc 5, 120
  play "C2", 3

  puts cache
end
