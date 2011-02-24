require 'params_validator/parameter'

#
# Juan de Bravo <juandebravo@gmail.com>
#
module ParamsValidator

  #
  # This class models the information required to validate
  # a specific method call
  #
  class MethodValidation

    # fully qualified method name
    attr_accessor :method_name

    # parameters expected by the method
    attr_accessor :parameters

    #
    # MethodValidation constructor
    # @param method_name fully qualified method name (Module::Class::method)
    # @param block the block to be executed
    #
    def initialize(method_name, &block)
      @method_name = method_name
      @parameters = []
      block_given? and self.instance_eval &block
    end

    # get mandatory parameters
    def mandatories
      values = []
      @parameters.each{|param|
        param.mandatory? and values << param
      }
      values
    end

    #
    # Execute validation block in this object scope
    #
    def block(&block)
      block_given? and self.instance_eval &block
    end

    #
    # DSL that defines the validation rules.
    # parameter (Object, :optional = false) { block }
    #
    def method_missing(meth, *args, &block)

      if args.length < 2
        optional = false
      else
        if args[1].eql?(:optional)
          optional = true
        else
          optional = false
        end
      end

      parameter = Parameter.new(meth, args.length < 1 ? Object : args[0], optional, block)
      @parameters.push parameter
    end

  end
end

