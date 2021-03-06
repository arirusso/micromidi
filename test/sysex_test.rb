require "helper"

class SysexTest < Minitest::Test

  def test_command
    m = MicroMIDI.message
    m.sysex_node 0x41, :model_id => 0x42, :device_id => 0x10
    message = m.sysex_command [0x40, 0x7F, 0x00], 0x00
    assert_equal(MIDIMessage::SystemExclusive::Command, message.class)
    assert_equal([0x40, 0x7F, 0x00], message.address)
    assert_equal(0, message.data)
    assert_equal([0xF0, 0x41, 0x10, 0x42, 0x12, 0x40, 0x7F, 0x00, 0x00, 0x41, 0xF7], message.to_bytes)
  end

  def test_request
    m = MicroMIDI.message
    m.sysex_node 0x41, :model_id => 0x42, :device_id => 0x10
    message = m.sysex_request [0x40, 0x7F, 0x00], 0x02
    assert_equal(MIDIMessage::SystemExclusive::Request, message.class)
    assert_equal([0x40, 0x7F, 0x00], message.address)
    assert_equal([0x0, 0x0, 0x02], message.size)
    assert_equal([0xF0, 0x41, 0x10, 0x42, 0x11, 0x40, 0x7F, 0x00, 0x0, 0x0, 0x02, 0x3F, 0xF7], message.to_bytes)
  end

  def test_message
    m = MicroMIDI.message
    message = m.sysex_message [0x42, 0x11, 0x40, 0x7F, 0x00, 0x0, 0x0, 0x02]
    assert_equal(MIDIMessage::SystemExclusive::Message, message.class)
    assert_equal([0x42, 0x11, 0x40, 0x7F, 0x00, 0x0, 0x0, 0x02], message.data)
    assert_equal([0xF0,  0x42, 0x11, 0x40, 0x7F, 0x00, 0x0, 0x0, 0x02, 0xF7], message.to_bytes)
  end

  def test_message_with_node
    m = MicroMIDI.message
    m.sysex_node 0x41, :model_id => 0x42, :device_id => 0x10
    message = m.sysex_message [0x42, 0x11, 0x40, 0x7F, 0x00, 0x0, 0x0, 0x02]
    assert_equal(MIDIMessage::SystemExclusive::Message, message.class)
    assert_equal([0x42, 0x11, 0x40, 0x7F, 0x00, 0x0, 0x0, 0x02], message.data)
    assert_equal([0xF0, 0x41, 0x10, 0x42, 0x42, 0x11, 0x40, 0x7F, 0x00, 0x0, 0x0, 0x02, 0xF7], message.to_bytes)
  end

  def test_no_model_id
    m = MicroMIDI.message
    m.sysex_node 0x41, :device_id => 0x10
    message = m.sysex_command [0x40, 0x7F, 0x00], 0x00
    assert_equal(MIDIMessage::SystemExclusive::Command, message.class)
    assert_equal([0x41, 0x10], message.node.to_a)
    assert_equal([0x40, 0x7F, 0x00], message.address)
    assert_equal(0, message.data)
    assert_equal([0xF0, 0x41, 0x10, 0x12, 0x40, 0x7F, 0x00, 0x00, 0x41, 0xF7], message.to_bytes)
  end

end
