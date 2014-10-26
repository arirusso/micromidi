#!/usr/bin/env ruby
$:.unshift File.join( File.dirname( __FILE__ ), '../lib')

require "micromidi"

# Demonstrates MicroMIDI shorthand

i = UniMIDI::Input.gets
o = UniMIDI::Output.gets

M(i, o) do

  rc :n do |m|
    m.note += 12
    out(m)
  end

  tu :n

  l { w }

end
