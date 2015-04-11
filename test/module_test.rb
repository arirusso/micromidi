require "helper"

class ModuleTest < Minitest::Test

  context "MIDI" do

    should "have MIDI module" do
      refute_nil MIDI
      assert_equal MicroMIDI, MIDI
    end

    should "add UniMIDI modules" do
      assert_equal UniMIDI::Input, MIDI::Input
      assert_equal UniMIDI::Output, MIDI::Output
    end

  end

end
