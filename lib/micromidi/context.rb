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
    
    # open a block for editing/live coding in this Context
    def edit(&block)
      instance_eval(&block)
    end
    
    def repeat
      send(@state.last_command[:method], *@state.last_command[:args]) unless @state.last_command.nil?
    end
    
    def method_missing(method, *args, &block)
      result = dsl(method, *args, &block)
      if result.keys.empty?
        super
      else
        return_value = result.values.compact[0]
        @state.record(method, args, block, return_value)
        return_value
      end
    end

    private

    def delegate(instruction_types, method, args, options = {}, &block)
      result = {}
      instruction_types.each do |key|
        dsl = @instructions[key]
        if dsl.respond_to?(method)
          message = dsl.send(method, *args, &block)
          result[key] = if @state.auto_output && !!options[:with_output]
            @instructions[:output].output(message)
          else
            message
          end
        end
      end 
      result
    end

    def dsl(method, *args, &block)
      results = []
      with_output = [:sysex, :message, :process]
      results << delegate(with_output, method, args, :with_output => true, &block)
      without_output = [:input, :output, :sticky]
      results << delegate(without_output, method, args, :with_output => false, &block)
      results.reduce(&:merge)
    end
        
  end
end
