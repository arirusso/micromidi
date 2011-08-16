#!/usr/bin/env ruby
$:.unshift File.join( File.dirname( __FILE__ ), '../lib')

require "micromidi"

output = UniMIDI::Output.first.open

MIDI.message do
  channel 4
  velocity 120
  play "C4", 1
end 