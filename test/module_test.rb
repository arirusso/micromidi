require "helper"

class ModuleTest < Minitest::Test

  context "MIDI" do

    should "add UniMIDI modules" do
      assert_equal UniMIDI::Input, MIDI::Input
      assert_equal UniMIDI::Output, MIDI::Output
    end

  end

end
