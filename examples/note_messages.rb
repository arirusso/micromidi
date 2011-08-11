#!/usr/bin/env ruby
$:.unshift File.join( File.dirname( __FILE__ ), '../lib')

require "midi-messenger"

output = UniMIDI::Output.first.open

MIDI.message(output) do
  channel 4
  velocity 120
  play "C4", 1
end 