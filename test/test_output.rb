#!/usr/bin/env ruby

require 'helper'

class OutputTest < Test::Unit::TestCase

  include MicroMIDI
  include MIDIMessage
  include TestHelper

  def test_auto_output
    m = MicroMIDI.message($test_device[:output].open)
    assert_equal(true, m.state.auto_output)
    m.output false
    assert_equal(false, m.state.auto_output)
    m.output true
    assert_equal(true, m.state.auto_output)
  end
            
end

