#!/usr/bin/env ruby

require 'helper'

class SysexTest < Test::Unit::TestCase

  include MicroMIDI
  include MIDIMessage
  include TestHelper
  
  def test_command
    m = MicroMIDI.message
    m.sysex_node 0x41, :model_id => 0x42, :device_id => 0x10
    msg = m.sysex_command [0x40, 0x7F, 0x00], 0x00
    assert_equal(SystemExclusive::Command, msg.class)
    assert_equal([0x40, 0x7F, 0x00], msg.address)
    assert_equal(0, msg.data)
    assert_equal([0xF0, 0x41, 0x10, 0x42, 0x12, 0x40, 0x7F, 0x00, 0x00, 0x41, 0xF7], msg.to_bytes)
  end
  
  def test_request
    m = MicroMIDI.message
    m.sysex_node 0x41, :model_id => 0x42, :device_id => 0x10
    msg = m.sysex_request [0x40, 0x7F, 0x00], 0x02
    assert_equal(SystemExclusive::Request, msg.class)
    assert_equal([0x40, 0x7F, 0x00], msg.address)
    assert_equal([0x0, 0x0, 0x02], msg.size)
    assert_equal([0xF0, 0x41, 0x10, 0x42, 0x11, 0x40, 0x7F, 0x00, 0x0, 0x0, 0x02, 0x3F, 0xF7], msg.to_bytes)   
  end

  def test_message
    m = MicroMIDI.message  
    msg = m.sysex_message [0x42, 0x11, 0x40, 0x7F, 0x00, 0x0, 0x0, 0x02]
    assert_equal(SystemExclusive::Message, msg.class)
    assert_equal([0x42, 0x11, 0x40, 0x7F, 0x00, 0x0, 0x0, 0x02], msg.data)
    assert_equal([0xF0,  0x42, 0x11, 0x40, 0x7F, 0x00, 0x0, 0x0, 0x02, 0xF7], msg.to_bytes)   
  end
  
  def test_no_model_id
    m = MicroMIDI.message
    m.sysex_node 0x41, :device_id => 0x10
    msg = m.sysex_command [0x40, 0x7F, 0x00], 0x00
    assert_equal(SystemExclusive::Command, msg.class)
    assert_equal([0x41, 0x10], msg.node.to_a)
    assert_equal([0x40, 0x7F, 0x00], msg.address)
    assert_equal(0, msg.data)
    assert_equal([0xF0, 0x41, 0x10, 0x12, 0x40, 0x7F, 0x00, 0x00, 0x41, 0xF7], msg.to_bytes)
  end
      
end

