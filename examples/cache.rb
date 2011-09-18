#!/usr/bin/env ruby
$:.unshift File.join( File.dirname( __FILE__ ), '../lib')

require "micromidi"

# this example demonstrates printing the cache

output = UniMIDI::Output.use(0)

MIDI.using(output) do
  note "C4"
  cc 5, 120
  play "C2", 3
  
  puts cache
end