module MicroMIDI

  # The DSL state
  class State

    DEFAULT = {
      :channel => 0,
      :octave => 2,
      :velocity => 100
    }

    attr_accessor :auto_output,
    :channel,
    :last_note,
    :octave,
    :sysex_node,
    :super_sticky,
    :velocity

    attr_reader :inputs,
    :last_command,
    :listeners,
    :outputs,
    :output_cache,
    :start_time,
    :thru_listeners

    # @param [Array<UniMIDI::Input>, UniMIDI::Input] inputs
    # @param [Array<UniMIDI::Output, IO>, IO, UniMIDI::Output] outputs
    # @param [Hash] options
    # @option options [Integer] :channel
    # @option options [Integer] :octave
    # @option options [Integer] :velocity
    def initialize(inputs, outputs, options = {})
      @inputs = [inputs].flatten
      @outputs = [outputs].flatten

      @channel = options[:channel] || DEFAULT[:channel]
      @velocity = options[:velocity] || DEFAULT[:velocity]
      @octave = options[:octave] || DEFAULT[:octave]

      @auto_output = true
      @last_command = nil
      @last_note = nil
      @listeners = []
      @thru_listeners = []
      @output_cache = []
      @start_time = Time.now.to_f
      @super_sticky = false
    end

    # Record that a command was used
    # @param [Symbol, String] method
    # @param [Array<Object>] args
    # @param [Proc] block
    # @param [Object] result
    def record(method, args, block, result)
      timestamp = now
      message = {
        :message => result,
        :timestamp => timestamp
      }
      @output_cache << message
      @last_command = {
        :method => method,
        :args => args,
        :block => block,
        :timestamp => timestamp
      }
    end

    #
    # Toggles super_sticky mode, a mode where any explicit values used to create MIDI messages
    # automatically become sticky.  Normally the explicit value would only be used for
    # the current message.
    #
    # For example, while in super sticky mode
    #
    # ```ruby
    # note "C4", :channel => 5
    # note "C3"
    # ```
    #
    # will have the same results as
    #
    # ```ruby
    # channel 5
    # note "C4"
    # note "C3"
    # ```
    #
    # @return [Boolean]
    def toggle_super_sticky
      @super_sticky = !@super_sticky
    end

    # Toggles auto-output mode.  In auto-output mode, any messages that are instantiated are sent to
    # any available MIDI outputs.
    # @return [Boolean]
    def toggle_auto_output
      @auto_output = !@auto_output
    end

    # Return message properties with regard to the current state
    # @param [Hash] options
    # @param [*Symbol] properties
    # @return [Hash]
    def message_properties(options, *properties)
      result = {}
      properties.each do |property|
        result[property] = options[property]
        if !result[property].nil? && (send(property).nil? || @super_sticky)
          send("#{property.to_s}=", result[property])
        end
        result[property] ||= send(property.to_s)
      end
      result
    end

    private

    # A timestamp
    # @return [Float]
    def now
      time = Time.now.to_f - @start_time
      time * 1000
    end

  end

end
