#!/usr/bin/env ruby
$:.unshift File.join( File.dirname( __FILE__ ), '../lib')

require "midi-messenger"

output = UniMIDI::Output.first.open

MIDI.message(output) do
  note "C4"
  cc 5, 120
end 