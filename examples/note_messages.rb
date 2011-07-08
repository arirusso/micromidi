#!/usr/bin/env ruby
$:.unshift File.join( File.dirname( __FILE__ ), '../lib')

require "midi-dsl"

MIDI.message do
  channel 0
  velocity 100
  p note "C4"
end 