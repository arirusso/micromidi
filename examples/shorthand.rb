#!/usr/bin/env ruby
$:.unshift File.join( File.dirname( __FILE__ ), '../lib')

require "micromidi"

i = UniMIDI::Input.first.open
o = UniMIDI::Output.first.open

MIDI.m(i, o) do
  
  r :n do |m|
    m.note += 12
    out(m)
  end
  
  t :n
  
  w
  
end 