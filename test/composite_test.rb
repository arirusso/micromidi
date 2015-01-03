require "helper"

class CompositeTest < Minitest::Test

  include MicroMIDI
  include MIDIMessage
  include TestHelper

  def test_play
    m = MicroMIDI.message
    start = Time.now
    msg = m.play "C0", 0.5

    finish = Time.now
    dif = finish - start
    assert_equal(true, dif >= 0.5)

    assert_equal(NoteOn, msg.class)
    assert_equal(12, msg.note)
    assert_equal(0, msg.channel)
    assert_equal(2, m.state.output_cache.size)

    off_msg = m.state.output_cache.last[:message]
    assert_equal(NoteOff, off_msg.class)
    assert_equal(12, off_msg.note)
    assert_equal(0, off_msg.channel)
  end

  def test_play_chord
    m = MicroMIDI.message
    start = Time.now
    msgs = m.play "C0", "E1", "G2", 0.5

    finish = Time.now
    dif = finish - start
    assert_equal(true, dif >= 0.5)

    msg = msgs.first

    assert_equal(NoteOn, msg.class)
    assert_equal(12, msg.note)
    assert_equal(0, msg.channel)
    assert_equal(6, m.state.output_cache.size)

    off_msg = m.state.output_cache.last[:message]
    assert_equal(NoteOff, off_msg.class)
    assert_equal(43, off_msg.note)
    assert_equal(0, off_msg.channel)
  end

  def test_play_chord_array
    m = MicroMIDI.message
    start = Time.now
    msgs = m.play ["C0", "E1", "G2"], 0.5

    finish = Time.now
    dif = finish - start
    assert_equal(true, dif >= 0.5)

    msg = msgs.first

    assert_equal(NoteOn, msg.class)
    assert_equal(12, msg.note)
    assert_equal(0, msg.channel)
    assert_equal(6, m.state.output_cache.size)

    off_msg = m.state.output_cache.last[:message]
    assert_equal(NoteOff, off_msg.class)
    assert_equal(43, off_msg.note)
    assert_equal(0, off_msg.channel)
  end

  def test_all_off

  end

end
