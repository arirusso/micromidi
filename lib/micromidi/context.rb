module MicroMIDI

  # The DSL context
  class Context

    include Instructions::Composite
    extend Forwardable

    attr_reader :state

    def_delegator :state, :output_cache, :cache

    # @param [Array<UniMIDI::Input>, UniMIDI::Input] inputs
    # @param [Array<UniMIDI::Output, IO>, IO, UniMIDI::Output] outputs
    # @param [Proc] block
    def initialize(inputs, outputs, &block)

      @state = State.new(inputs, outputs)

      @instructions = {
        :process => Instructions::Process.new(@state),
        :message => Instructions::Message.new(@state),
        :output => Instructions::Output.new(@state),
        :sticky => Instructions::Sticky.new(@state),
        :sysex => Instructions::SysEx.new(@state)
      }
      @instructions[:input] = Instructions::Input.new(@state) { |message| @instructions[:output].output(message) }

      edit(&block) if block_given?
    end

    # Eval a block for editing/live coding in this context
    # @param [Proc] block
    # @return [Object]
    def edit(&block)
      instance_eval(&block)
    end

    # Repeat the last instruction in the history
    # @return [Object]
    def repeat
      unless @state.last_command.nil?
        send(@state.last_command[:method], *@state.last_command[:args])
      end
    end

    # Delegates a command to one of the instruction classes
    # @param [Symbol] method
    # @param [*Object] args
    # @param [Proc] block
    # @return [Object]
    def method_missing(method, *args, &block)
      results = delegate(method, args, &block)
      if results.empty?
        super
      else
        messages = results.map do |result|
          @state.record(method, args, block, result[:message])
          @instructions[:output].output(result[:message]) if output?(result[:instruction_type])
          result[:message]
        end
        messages.compact.first
      end
    end

    private

    # Should a message that resulted from the given instruction type be outputted?
    # @param [Symbol] instruction_type
    # @return [Boolean]
    def output?(instruction_type)
      @state.auto_output && [:sysex, :message, :process].include?(instruction_type)
    end

    # Delegate a command
    # @param [Symbol] method
    # @param [*Object] args
    # @param [Proc] block
    # @return [Object]
    def delegate(method, args, &block)
      results = @instructions.map do |key, instruction|
        if instruction.respond_to?(method)
          message = instruction.send(method, *args, &block)
          {
            :instruction_type => key,
            :message => message
          }
        end
      end
      results.compact
    end

  end
end
