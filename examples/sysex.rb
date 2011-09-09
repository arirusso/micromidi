#!/usr/bin/env ruby
$:.unshift File.join( File.dirname( __FILE__ ), '../lib')

require "micromidi"

# this example converts controller messages to SysEx commands

@i = UniMIDI::Input.use(:first)
@o = UniMIDI::Output.use(:first)
  
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