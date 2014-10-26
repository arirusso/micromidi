#
# MicroMIDI
#
# A Ruby DSL for MIDI
#
# (c)2011-2014 Ari Russo
# Apache 2.0 License
#

# libs
require "forwardable"
require "midi-eye"
require "midi-fx"
require "midi-message"
require "unimidi"

# modules
require "micromidi/device"
require "micromidi/instructions/composite"
require "micromidi/module_methods"

# classes
require "micromidi/context"
require "micromidi/state"
require "micromidi/instructions/process"
require "micromidi/instructions/input"
require "micromidi/instructions/message"
require "micromidi/instructions/output"
require "micromidi/instructions/sticky"
require "micromidi/instructions/sysex"

# extension
require "micromidi/instructions/shorthand"

module MicroMIDI

  VERSION = "0.1.3"

end
MIDI = MicroMIDI
