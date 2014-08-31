module MicroMIDI

  module Instructions
    
    class Output
      
      def initialize(state)
        @state = state
      end

      def output(msg)
        auto_output(msg) if msg === false || msg === true
        @state.outputs.each { |o| o.puts(msg) } unless msg.nil?
        msg
      end
      
      # toggle mode where messages are automatically outputted
      def auto_output(mode = nil)
        mode.nil? ? @state.toggle_auto_output : @state.auto_output = mode
      end

    end

  end

end
