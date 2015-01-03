require "helper"

class StickyTest < Minitest::Test

  include MicroMIDI
  include TestHelper

  def test_channel
    m = MicroMIDI.message
    msg = m.note "C0"
    assert_equal(MIDIMessage::NoteOn, msg.class)
    assert_equal(12, msg.note)
    assert_equal(0, msg.channel)

    m.channel 7
    msg = m.note "C0"
    assert_equal(MIDIMessage::NoteOn, msg.class)
    assert_equal(12, msg.note)
    assert_equal(7, msg.channel)
  end

  def test_channel_override
    m = MicroMIDI.message
    m.channel 7
    msg = m.note "C0", :channel => 3
    assert_equal(MIDIMessage::NoteOn, msg.class)
    assert_equal(12, msg.note)
    assert_equal(3, msg.channel)
    assert_equal(100, msg.velocity)

    msg = m.note "C0"
    assert_equal(MIDIMessage::NoteOn, msg.class)
    assert_equal(12, msg.note)
    assert_equal(7, msg.channel)
    assert_equal(100, msg.velocity)
  end

  def test_velocity
    m = MicroMIDI.message
    msg = m.note "C0"
    assert_equal(MIDIMessage::NoteOn, msg.class)
    assert_equal(12, msg.note)
    assert_equal(0, msg.channel)
    assert_equal(100, msg.velocity)

    m.velocity 10
    msg = m.note "C0"
    assert_equal(MIDIMessage::NoteOn, msg.class)
    assert_equal(12, msg.note)
    assert_equal(0, msg.channel)
    assert_equal(10, msg.velocity)
  end

  def test_octave
    m = MicroMIDI.message
    msg = m.note "C"
    assert_equal(MIDIMessage::NoteOn, msg.class)
    assert_equal(36, msg.note)
    assert_equal(0, msg.channel)
    assert_equal(100, msg.velocity)

    m.octave 4
    msg = m.note "C"
    assert_equal(MIDIMessage::NoteOn, msg.class)
    assert_equal(60, msg.note)
    assert_equal(0, msg.channel)
    assert_equal(100, msg.velocity)
  end

  def test_octave_super_sticky
    m = MicroMIDI.message
    m.super_sticky

    msg = m.note "C"
    assert_equal(MIDIMessage::NoteOn, msg.class)
    assert_equal(36, msg.note)
    assert_equal(0, msg.channel)
    assert_equal(100, msg.velocity)

    m.octave 4
    msg = m.note "C0"
    assert_equal(MIDIMessage::NoteOn, msg.class)
    assert_equal(12, msg.note)
    assert_equal(0, msg.channel)
    assert_equal(100, msg.velocity)

    msg = m.note "D"
    assert_equal(MIDIMessage::NoteOn, msg.class)
    assert_equal(14, msg.note)
    assert_equal(0, msg.channel)
    assert_equal(100, msg.velocity)
  end

  def test_velocity_super_sticky
    m = MicroMIDI.message
    m.super_sticky

    msg = m.note "C0"
    assert_equal(MIDIMessage::NoteOn, msg.class)
    assert_equal(12, msg.note)
    assert_equal(0, msg.channel)
    assert_equal(100, msg.velocity)

    m.velocity 10
    msg = m.note "C0", :velocity => 20
    assert_equal(MIDIMessage::NoteOn, msg.class)
    assert_equal(12, msg.note)
    assert_equal(0, msg.channel)
    assert_equal(20, msg.velocity)

    msg = m.note "C1"
    assert_equal(MIDIMessage::NoteOn, msg.class)
    assert_equal(24, msg.note)
    assert_equal(0, msg.channel)
    assert_equal(20, msg.velocity)
  end

  def test_sysex_node
    m = MicroMIDI.message
    assert_equal(nil, m.sysex_node)

    node = m.node 0x41, :model_id => 0x42, :device_id => 0x10
    assert_equal(MIDIMessage::SystemExclusive::Node, node.class)
    assert_equal(65, node.manufacturer_id)
    assert_equal(66, node.model_id)
    assert_equal(16, node.device_id)

  end

end
