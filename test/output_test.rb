require "helper"

class OutputTest < Minitest::Test

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
