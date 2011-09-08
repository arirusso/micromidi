#!/usr/bin/env ruby
$:.unshift File.join( File.dirname( __FILE__ ), '../lib')

require "micromidi"

MIDI.using($stdout) do
  
  # set sticky values
  channel 4
  velocity 64
  
  # create some objects
  note_msg = note "C4"
  controller_msg = cc 2, 120
  patch_change_msg = pc 5
  
end 

#
# this should print something like the following to the console:
#

##<MIDIMessage::NoteOn:0x8f76694
# @channel=4,
# @const=#<MIDIMessage::Constant:0x8f78fe8 @key="C4", @value=60>,
# @data=[60, 64],
# @name="C4",
# @note=60,
# @status=[9, 4],
# @velocity=64,
# @verbose_name="Note On: C4">
##<MIDIMessage::ControlChange:0x8f4f850
# @channel=4,
# @const=nil,
# @data=[2, 120],
# @index=2,
# @name="Breath Controller",
# @status=[11, 4],
# @value=120,
# @verbose_name="Control Change: Breath Controller">
##<MIDIMessage::ProgramChange:0x8f4f0d0
# @channel=4,
# @const=nil,
# @data=[5],
# @program=5,
# @status=[12, 4]>
#