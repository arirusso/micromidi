#!/usr/bin/env ruby
$:.unshift File.join( File.dirname( __FILE__ ), '../lib')

require "micromidi"

i = UniMIDI::Input.first.open
o = UniMIDI::Output.first.open

M(i, o) do
  
  rc :n do |m|
    m.note += 12
    out(m)
  end
  
  tu :n
  
  l { w }
  
end 