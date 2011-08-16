#!/usr/bin/env ruby
$:.unshift File.join( File.dirname( __FILE__ ), '../lib')

require "micromidi"

output = UniMIDI::Output.first.open

sesh = MIDI.message(output) do
  note "C4"
  cc 5, 120
  play "C2", 3
end

p sesh.output_cache