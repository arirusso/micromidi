#!/usr/bin/env ruby
$:.unshift(File.join("..", "lib"))

require "micromidi"

# Prompts the user to select a MIDI input and output
# Control change messages that are sent to the input are converted to SysEx commands and sent
# to the output.

@i = UniMIDI::Input.gets
@o = UniMIDI::Output.gets

MIDI.using(@i, @o) do

  node 0x41, 0x42, :device_id => 0x10

  *@my_map =
    [0x40, 0x7F, 0x00],
    [0x41, 0x7F, 0x00],
    [0x42, 0x7F, 0x00]

  receive :cc do |message|

    sysex_command @my_map[message.index - 1], message.value

  end

  join

end
