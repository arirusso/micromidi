#!/usr/bin/env ruby
$:.unshift File.join( File.dirname( __FILE__ ), '../lib')

require "looplang"

output = UniMIDI::Output.first.open

bass = MIDI.track(output, :tempo => 130, :resolution => 16) do
  
  at 4, 3, note("C4")
  at 4, cc(5, 120)
  
  loop 1, 16
  
end 

drums = MIDI.track(output, :tempo => 130, :resolution => 16) do
  
  hihat = note("C3")
  kick = note("A1")
  snare = note("B1")
  
  at :odd, 1, hihat
  at [1,9], 1, kick
  at [5,13], 1, snare
  
  erase 5
  
end

bass.sync_to(drums)

drums.play