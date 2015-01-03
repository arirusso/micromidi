require "helper"

class StateTest < Minitest::Test

  include MicroMIDI
  include MIDIMessage
  include TestHelper

  def test_output_cache
    m = MicroMIDI.message
    cache = m.state.output_cache

    m.note "C0"
    assert_equal(1, cache.size)

    m.note "C3"
    assert_equal(2, cache.size)
  end

  def test_start_time
    t1 = Time.now.to_f
    m = MicroMIDI.message
    t2 = Time.now.to_f
    t = m.state.start_time
    assert_equal(true, t1 < t)
    assert_equal(true, t < t2)
  end

end
