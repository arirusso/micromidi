#!/usr/bin/env ruby
$:.unshift File.join( File.dirname( __FILE__ ), '../lib')

require "micromidi"

MIDI.message do
  
  # set sticky values
  channel 4
  velocity 120
  
  # create some objects
  note_msg = note "C4"
  controller_msg = cc 2, 120
  patch_change_msg = pc 5
  
  # inspect the messages
  p note_msg
  p controller_msg
  p patch_change_msg
  
end 

#
# this should print something like the following to the console:
#
