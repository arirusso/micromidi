module MicroMIDI
  
  class Context
    
    include Instructions::Composite
    extend Forwardable
    
    attr_reader :state
    
    def_delegator :state, :output_cache, :cache
            
    def initialize(ins, outs, &block)
      
      @state = State.new(ins, outs)
      
      @instructions = {
        :process => Instructions::Process.new(@state),
        :input => Instructions::Input.new(@state),      
        :message => Instructions::Message.new(@state),
        :output => Instructions::Output.new(@state),
        :sticky => Instructions::Sticky.new(@state),
        :sysex => Instructions::SysEx.new(@state)
      }
       
      edit(&block) unless block.nil?
    end
    
    # Open a block for editing/live coding in this Context
    def edit(&block)
      instance_eval(&block)
    end
    
    # Repeat the last instruction in the history
    def repeat
      send(@state.last_command[:method], *@state.last_command[:args]) unless @state.last_command.nil?
    end
    
    # Delegates a command to one of the instruction classes
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
    def output?(instruction_type)
      @state.auto_output && [:sysex, :message, :process].include?(instruction_type)
    end

    # Delegate a command 
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
