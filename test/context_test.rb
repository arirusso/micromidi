require "helper"

class ContextTest < Minitest::Test

  def test_new_with_block
    msg = nil
    MIDI::IO.new do
      msg = note "C0"
    end
    assert_equal(MIDIMessage::NoteOn, msg.class)
    assert_equal(12, msg.note)
    assert_equal(0, msg.channel)
  end

  def test_new_with_no_block
    m = MIDI::IO.new
    msg = m.note "C0"
    assert_equal(MIDIMessage::NoteOn, msg.class)
    assert_equal(12, msg.note)
    assert_equal(0, msg.channel)
  end

  def test_edit
    msg = nil
    m = MIDI::IO.new
    m.edit do
      msg = m.note "C0"
    end
    assert_equal(MIDIMessage::NoteOn, msg.class)
    assert_equal(12, msg.note)
    assert_equal(0, msg.channel)
  end

  def test_repeat
    m = MicroMIDI.message
    msg = m.note "C0"
    assert_equal(MIDIMessage::NoteOn, msg.class)
    assert_equal(12, msg.note)
    assert_equal(0, msg.channel)

    r_msg = m.repeat
    assert_equal(MIDIMessage::NoteOn, r_msg.class)
    assert_equal(12, r_msg.note)
    assert_equal(0, r_msg.channel)
  end

end
