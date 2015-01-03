require "helper"

class MessageTest < Minitest::Test

  include MicroMIDI
  include TestHelper

  def test_cc
    m = MicroMIDI.message
    msg = m.cc 16, 12
    assert_equal(MIDIMessage::ControlChange, msg.class)
    assert_equal(16, msg.index)
    assert_equal(12, msg.value)
  end

  def test_channel_aftertouch
    m = MicroMIDI::IO.new
    msg = m.channel_aftertouch 2, :channel => 1
    assert_equal(MIDIMessage::ChannelAftertouch, msg.class)
    assert_equal(1, msg.channel)
    assert_equal(2, msg.value)
  end

  def test_poly_aftertouch
    m = MicroMIDI::IO.new
    msg = m.poly_aftertouch 64, 2, :channel => 1
    assert_equal(MIDIMessage::PolyphonicAftertouch, msg.class)
    assert_equal(1, msg.channel)
    assert_equal(64, msg.note)
    assert_equal(2, msg.value)
  end

  def test_pitch_bend
    m = MicroMIDI::IO.new
    msg = m.pitch_bend 64, 2, :channel => 1
    assert_equal(MIDIMessage::PitchBend, msg.class)
    assert_equal(1, msg.channel)
    assert_equal(64, msg.low)
    assert_equal(2, msg.high)
  end

  def test_note_off
    m = MicroMIDI.message
    msg = m.note_off 13, :channel => 9, :velocity => 80
    assert_equal(MIDIMessage::NoteOff, msg.class)
    assert_equal(13, msg.note)
    assert_equal(9, msg.channel)
    assert_equal(80, msg.velocity)
  end

  def test_note_on_string
    m = MicroMIDI.message
    msg = m.note "C0", :velocity => 94
    assert_equal(MIDIMessage::NoteOn, msg.class)
    assert_equal(12, msg.note)
    assert_equal(94, msg.velocity)
  end

  def test_note_on_string_no_octave
    m = MicroMIDI.message
    msg = m.note "C", :velocity => 94
    assert_equal(MIDIMessage::NoteOn, msg.class)
    assert_equal(36, msg.note)
    assert_equal(94, msg.velocity)
  end

  def test_note_on_int
    m = MicroMIDI.message
    msg = m.note 12, :channel => 3
    assert_equal(MIDIMessage::NoteOn, msg.class)
    assert_equal(12, msg.note)
    assert_equal(3, msg.channel)
  end

  def test_note_on_symbol
    m = MicroMIDI.message
    msg = m.note :C0
    assert_equal(MIDIMessage::NoteOn, msg.class)
    assert_equal(12, msg.note)
    assert_equal(100, msg.velocity)
  end

  def test_note_on_symbol_no_octave
    m = MicroMIDI.message
    msg = m.note :C
    assert_equal(MIDIMessage::NoteOn, msg.class)
    assert_equal(36, msg.note)
    assert_equal(100, msg.velocity)
  end

  def test_parse
    m = MicroMIDI.message
    msg = m.parse "906040"
    assert_equal(MIDIMessage::NoteOn, msg.class)
    assert_equal(96, msg.note)
    assert_equal(0, msg.channel)
    assert_equal(64, msg.velocity)
  end

  def test_program_change
    m = MicroMIDI.message
    msg = m.program_change 15
    assert_equal(MIDIMessage::ProgramChange, msg.class)
    assert_equal(15, msg.program)
  end

  def test_off
    m = MicroMIDI.message
    msg = m.note "C0", :channel => 3
    assert_equal(MIDIMessage::NoteOn, msg.class)
    assert_equal(12, msg.note)
    assert_equal(3, msg.channel)
    off_msg = m.off
    assert_equal(MIDIMessage::NoteOff, off_msg.class)
    assert_equal(12, off_msg.note)
    assert_equal(3, off_msg.channel)
  end

end
