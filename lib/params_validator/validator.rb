require 'params_validator/method_validation'
require 'params_validator/valid_params'

#
# Juan de Bravo <juandebravo@gmail.com>
#

module ParamsValidator

  #
  # This class
  #
  class Validator

    ERROR_MESSAGE_NULL  = "Parameter %s cannot be null"
    ERROR_MESSAGE_TYPE  = "Parameter %s present but invalid type %s"
    ERROR_MESSAGE_BLOCK = "Parameter %s present but does not match the ruleset"

    def initialize
      @methods_loaded = {}
    end

    #
    # This method loads new rules in memory
    # validatation_rule method do
    #   param1 (type) &block
    #   param2 (type) &block
    # end
    #
    def load_rules(rules)
      self.instance_eval(rules)
    end

    #
    # This method is part of the DSL and defines a new
    # validator rule
    # @param method_name fully qualified method name (Module::Class::method)
    # @param block the block to be executed
    #
    def validation_rule(method_name, &block)
      method = MethodValidation.new(method_name)
      block_given? and method.block &block
      @methods_loaded[:"#{method_name}"] = method
    end

    #
    # This method validates if the specific call to method_name is valid
    # @param method_name fully qualified method name (Module::Class::method)
    # @param params
    #
    def validate_params(method_name, params)

      # fetch method rulesets
      method = @methods_loaded[method_name.to_sym]

      if method.nil?
        # TODO enable devel or prod mode to raise or not an exception
        raise ArgumentError, "Unable to validate method #{method_name} with (#{@methods_loaded.keys.length}) keys #{@methods_loaded.keys}"
      end

      # fetch all params (optional and mandatory)
      check_params    = method.parameters

      if !check_params.nil? and params.nil?
        raise ArgumentError, "Nil parameters when #{check_params.length} expected"
      end

      # if just one param -> include as array with length 1
      if check_params.instance_of?(Array) && check_params.length == 1 && params.instance_of?(String)
        params = {check_params[0].name.to_sym => params}
      end

      # Validate the params
      check_params.each{|key|
        # get param
        param = params[key.name.to_sym]

        if key.optional? and param.nil? # argument optional and not present -> continue
          next
        end

        if param.nil? # argument mandatory and not present
          raise ArgumentError, ERROR_MESSAGE_NULL % key.name
        else
          # check argument type is valid
          unless param.is_a?(key.klass)
            raise ArgumentError, ERROR_MESSAGE_TYPE % [key.name, param.class]
          end

          # check argument satisfies ruleset (if present)
          unless key.rule.nil?
            !key.rule.call(param) and raise ArgumentError, ERROR_MESSAGE_BLOCK % key.name
          end
        end
      }
      # no exception -> successfully validated
      true

    end 

  end
end
