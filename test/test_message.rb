#!/usr/bin/env ruby

require 'helper'

class MessageTest < Test::Unit::TestCase

  include MicroMIDI
  include MIDIMessage
  include TestHelper
  
  def test_cc
    m = MicroMIDI.message
    msg = m.cc 16, 12
    assert_equal(ControlChange, msg.class)
    assert_equal(16, msg.index)
    assert_equal(12, msg.value)
  end
  
  def test_note_off
    m = MicroMIDI.message
    msg = m.note_off 13, :channel => 9, :velocity => 80
    assert_equal(NoteOff, msg.class)
    assert_equal(13, msg.note)
    assert_equal(9, msg.channel)
    assert_equal(80, msg.velocity)    
  end

  def test_note_on_string
    m = MicroMIDI.message
    msg = m.note "C0", :velocity => 94
    assert_equal(NoteOn, msg.class)
    assert_equal(12, msg.note)
    assert_equal(94, msg.velocity)
  end

  def test_note_on_int
    m = MicroMIDI.message
    msg = m.note 12, :channel => 3
    assert_equal(NoteOn, msg.class)
    assert_equal(12, msg.note)
    assert_equal(3, msg.channel)
  end
  
  def test_parse
    m = MicroMIDI.message
    msg = m.parse "906040"
    assert_equal(NoteOn, msg.class)
    assert_equal(96, msg.note)
    assert_equal(0, msg.channel)    
    assert_equal(64, msg.velocity)
  end
  
  def test_program_change
    m = MicroMIDI.message
    msg = m.program_change 15
    assert_equal(ProgramChange, msg.class)
    assert_equal(15, msg.program)    
  end
    
end

