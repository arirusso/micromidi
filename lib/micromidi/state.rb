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

    def initialize(inputs, outputs, options = {})
      @inputs = inputs
      @outputs = outputs

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

    def record(method, args, block, output)
      timestamp = now
      message = {
        :message => output,
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

    def toggle_super_sticky
      @super_sticky = !@super_sticky
    end

    def toggle_auto_output
      @auto_output = !@auto_output
    end

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

    def now
      time = Time.now.to_f - @start_time
      time * 1000
    end

  end

end
