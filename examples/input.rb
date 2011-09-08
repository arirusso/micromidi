#!/usr/bin/env ruby
$:.unshift File.join( File.dirname( __FILE__ ), '../lib')

require "micromidi"

input = UniMIDI::Input.use(0)
output = UniMIDI::Output.use(0)

MIDI.using(input, output) do
  
  thru_except :note do |message|
    message.note += 12
    output(message)
  end
  
  join
  
end 