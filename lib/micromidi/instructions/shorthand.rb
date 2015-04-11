module MicroMIDI
  # Patch shorthand aliases into the MicroMIDI module

  alias l loop

  def self.m(*args, &block)
    send(:message, *args, &block)
  end

  class Context
    alias_method :r, :repeat
  end

  module Instructions

    module Composite
      alias_method :console, :p # move Kernel#p
      alias_method :p, :play
      alias_method :q!, :all_off
      alias_method :x, :all_off
    end

    class Input
      alias_method :j, :join
      alias_method :rc, :receive
      alias_method :rcu, :receive_unless
      alias_method :t, :thru
      alias_method :te, :thru_except
      alias_method :tu, :thru_unless
      alias_method :w, :wait_for_input
    end

    class Message
      alias_method :c, :control_change
      alias_method :ca, :channel_aftertouch
      alias_method :cc, :control_change
      alias_method :n, :note
      alias_method :no, :note_off
      alias_method :o, :off
      alias_method :pa, :polyphonic_aftertouch
      alias_method :pb, :pitch_bend
      alias_method :pc, :program_change
    end

    class Output
      alias_method :out, :output
    end

    class Process
      alias_method :bp, :band_pass_filter
      alias_method :bpf, :band_pass_filter
      alias_method :br, :notch_filter
      alias_method :f, :filter
      alias_method :hp, :high_pass_filter
      alias_method :hpf, :high_pass_filter
      alias_method :l, :limit
      alias_method :lp, :low_pass_filter
      alias_method :lpf, :low_pass_filter
      alias_method :mbf, :filter
      alias_method :nf, :notch_filter
      alias_method :tp, :transpose
    end

    class Sticky
      alias_method :ch, :channel
      alias_method :ss, :super_sticky
      alias_method :v, :velocity
    end

    class SysEx
      alias_method :sc, :sysex_command
      alias_method :sr, :sysex_request
      alias_method :sx, :sysex_message
    end

  end
end

def M(*a, &block)
  MIDI.message(*a, &block)
end
