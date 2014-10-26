#!/usr/bin/env ruby
$:.unshift File.join( File.dirname( __FILE__ ), '../lib')

require "micromidi"

# Prompts the user to select a MIDI input and output
# Transposes MIDI notes that are sent to the input up one octave before sending them to the output

input = UniMIDI::Input.gets
output = UniMIDI::Output.gets

MIDI.using(input, output) do

  thru_except :note do |message|
    message.note += 12
    output(message)
  end

  join

end
