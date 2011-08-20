#!/usr/bin/env ruby

require 'helper'

class EffectTest < Test::Unit::TestCase

  include MicroMIDI
  include TestHelper

#!/usr/bin/env ruby

require 'helper'

class FilterTest < Test::Unit::TestCase

  include MicroMIDI
  include TestHelper

  def test_high_pass_note_reject
    msg, outp = nil, nil
    M do
      msg = note "C0"
      outp = hpf msg, :note, 20
    end   
    assert_equal(12, msg.note)
    assert_equal(nil, outp)
  end

  def test_high_pass_note_accept
    msg, outp = nil, nil
    M do
      msg = note "C4"
      outp = hpf msg, :note, 20
    end   
    assert_equal(60, msg.note)
    assert_equal(msg, outp)
  end

  def test_low_pass_note_reject
    msg, outp = nil, nil
    M do
      msg = note "C4"
      outp = lpf msg, :note, 50
    end   
    assert_equal(60, msg.note)
    assert_equal(nil, outp)
  end

  def test_low_pass_note_accept
    msg, outp = nil, nil
    M do
      msg = note "C4"
      outp = lp msg, :note, 100
    end   
    assert_equal(60, msg.note)
    assert_equal(msg, outp)
  end

  def test_band_pass_note_reject
    msg, outp = nil, nil
    M do
      msg = note "C4"
      outp = bpf msg, :note, (20..50)
    end   
    assert_equal(60, msg.note)
    assert_equal(nil, outp)
  end

  def test_band_pass_note_accept
    msg, outp = nil, nil
    M do
      msg = note "C4"
      outp = bp msg, :note, (20..100)
    end   
    assert_equal(60, msg.note)
    assert_equal(msg, outp)
  end
  
  def test_notch_note_reject
    msg, outp = nil, nil
    M do
      msg = note "C4"
      outp = nf msg, :note, (20..70)
    end   
    assert_equal(60, msg.note)
    assert_equal(nil, outp)
  end

  def test_notch_note_accept
    msg, outp = nil, nil
    M do
      msg = note "C4"
      outp = nf msg, :note, (20..50)
    end   
    assert_equal(60, msg.note)
    assert_equal(msg, outp)
  end
  
  def test_multiband_note_reject
    msg, outp = nil, nil
    M do
      msg = note "C4"
      outp = f msg, :note, [(20..30), (40..50)]
    end   
    assert_equal(60, msg.note)
    assert_equal(nil, outp)
  end

  def test_multiband_note_accept
    msg, outp = nil, nil
    M do
      msg = note "C4"
      outp = mbf msg, :note, [(20..30), (50..70)]
    end   
    assert_equal(60, msg.note)
    assert_equal(msg, outp)
  end
  
  def test_multinotch_note_reject
    msg, outp = nil, nil
    M do
      msg = note "C4"
      outp = mbf msg, :note, [(20..30), (55..65)], :reject => true
    end   
    assert_equal(60, msg.note)
    assert_equal(nil, outp)
  end

  def test_multinotch_note_accept
    msg, outp = nil, nil
    M do
      msg = note "C4"
      outp = mbf msg, :note, [(20..30), (40..50)], :reject => true
    end   
    assert_equal(60, msg.note)
    assert_equal(msg, outp)
  end
  
  def test_limit_low
    msg, outp = nil, nil
    M do
      msg = note "C0"
      outp = limit msg, :note, (20..50)
    end   
    assert_equal(20, msg.note)
  end

  def test_limit_high
    msg, outp = nil, nil
    M do
      msg = note "C6"
      outp = limit msg, :note, (20..50)
    end   
    assert_equal(50, msg.note)
  end
  
  def test_transpose_note_up
    msg, outp = nil, nil
    M do
      msg = note "C4"
      outp = transpose msg, :note, 5
    end   
    assert_equal(65, msg.note)
  end

  def test_transpose_velocity_down
    msg, outp = nil, nil
    M do
      msg = note "C4", :velocity => 82
      outp = transpose msg, :velocity, -10
    end   
    assert_equal(72, msg.velocity)
  end
  
end


end