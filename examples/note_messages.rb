#!/usr/bin/env ruby
$:.unshift File.join( File.dirname( __FILE__ ), '../lib')

require "midi-messenger"

MIDI.message do
  channel 4
  velocity 120
  p note "C4"
end 