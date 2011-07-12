#!/usr/bin/env ruby
$:.unshift File.join( File.dirname( __FILE__ ), '../lib')

require "midi-messenger"

input = UniMIDI::Input.first.open
output = UniMIDI::Output.first.open

MIDI.message(input, output) do
  
  receive :note do |message, timestamp|
    message.note += 12
    output message
  end
  
  thru_unless :note
  
end 