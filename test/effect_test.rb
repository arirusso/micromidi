require "helper"

class EffectTest < Minitest::Test

  include TestHelper

  def test_high_pass_note_reject
    m = MicroMIDI.message
    msg = m.note "C0"
    outp = m.hpf msg, :note, 20
    assert_equal(12, msg.note)
    assert_equal(nil, outp)
  end

  def test_high_pass_note_accept
    m = MicroMIDI.message
    msg = m.note "C4"
    outp = m.hpf msg, :note, 20
    assert_equal(60, msg.note)
    assert_equal(msg, outp)
  end

  def test_low_pass_note_reject
    m = MicroMIDI.message
    msg = m.note "C4"
    outp = m.lpf msg, :note, 50
    assert_equal(60, msg.note)
    assert_equal(nil, outp)
  end

  def test_low_pass_note_accept
    m = MicroMIDI.message
    msg = m.note "C4"
    outp = m.lp msg, :note, 100
    assert_equal(60, msg.note)
    assert_equal(msg, outp)
  end

  def test_band_pass_note_reject
    m = MicroMIDI.message
    msg = m.note "C4"
    outp = m.bpf msg, :note, (20..50)
    assert_equal(60, msg.note)
    assert_equal(nil, outp)
  end

  def test_band_pass_note_accept
    m = MicroMIDI.message
    msg = m.note "C4"
    outp = m.bp msg, :note, (20..100)
    assert_equal(60, msg.note)
    assert_equal(msg, outp)
  end

  def test_notch_note_reject
    m = MicroMIDI.message
    msg = m.note "C4"
    outp = m.nf msg, :note, (20..70)
    assert_equal(60, msg.note)
    assert_equal(nil, outp)
  end

  def test_notch_note_accept
    m = MicroMIDI.message
    msg = m.note "C4"
    outp = m.nf msg, :note, (20..50)
    assert_equal(60, msg.note)
    assert_equal(msg, outp)
  end

  def test_multiband_note_reject
    m = MicroMIDI.message
    msg = m.note "C4"
    outp = m.f msg, :note, [(20..30), (40..50)]
    assert_equal(60, msg.note)
    assert_equal(nil, outp)
  end

  def test_multiband_note_accept
    m = MicroMIDI.message
    msg = m.note "C4"
    outp = m.mbf msg, :note, [(20..30), (50..70)]
    assert_equal(60, msg.note)
    assert_equal(msg, outp)
  end

  def test_multinotch_note_reject
    m = MicroMIDI.message
    msg = m.note "C4"
    outp = m.mbf msg, :note, [(20..30), (55..65)], :reject => true
    assert_equal(60, msg.note)
    assert_equal(nil, outp)
  end

  def test_multinotch_note_accept
    m = MicroMIDI.message
    msg = m.note "C4"
    outp = m.mbf msg, :note, [(20..30), (40..50)], :reject => true
    assert_equal(60, msg.note)
    assert_equal(msg, outp)
  end

  def test_limit_low
    m = MicroMIDI.message
    msg = m.note "C0"
    outp = m.limit msg, :note, (20..50)
    assert_equal(20, msg.note)
  end

  def test_limit_high
    m = MicroMIDI.message
    msg = m.note "C6"
    outp = m.limit msg, :note, (20..50)
    assert_equal(50, msg.note)
  end

  def test_transpose_note_up
    m = MicroMIDI.message
    msg = m.note "C4"
    outp = m.transpose msg, :note, 5
    assert_equal(65, msg.note)
  end

  def test_transpose_velocity_down
    m = MicroMIDI.message
    msg = m.note "C4", :velocity => 82
    outp = m.transpose msg, :velocity, -10
    assert_equal(72, msg.velocity)
  end

end
