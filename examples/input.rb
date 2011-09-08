#!/usr/bin/env ruby
$:.unshift File.join( File.dirname( __FILE__ ), '../lib')

require "micromidi"

input = UniMIDI::Input.use(0)
output = UniMIDI::Output.use(0)

MIDI.using(input, output) do
  
  receive :note do |message|
    message.note += 12
    output(message)
  end
  
  thru_unless :note
  
  wait_for_input
  
end 