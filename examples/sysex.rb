#!/usr/bin/env ruby
$:.unshift File.join( File.dirname( __FILE__ ), '../lib')

require "micromidi"

# this example converts controller messages to SysEx commands

@i = UniMIDI::Input.use(0)
@o = UniMIDI::Output.use(0)

MIDI.using(@i, @o) do
  
  node 0x41, 0x42, :device_id => 0x10
  
  receive :cc do |message|
    case message.index
      when 0 then sysex_command [0x40, 0x7F, 0x00], message.value
    end
  end
  
  join
  
end 