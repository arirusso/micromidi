#!/usr/bin/env ruby

require 'helper'

class IoTest < Test::Unit::TestCase

  include MicroMIDI
  include TestHelper
  include TestHelper::Config # before running these tests, adjust the constants in config.rb to suit your hardware setup

  # ** this test assumes that TestOutput is connected to TestInput
  def test_full_io
  end

end