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

    attr_reader :methods_loaded

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
    # This method is part of the DSL and defines a new validator rule
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
      errors = []

      # fetch method rulesets
      method = @methods_loaded[method_name.to_sym]

      if method.nil?
        # TODO enable devel or prod mode to raise or not an exception
        errors.push "Unable to validate method #{method_name} with (#{@methods_loaded.keys.length}) keys #{@methods_loaded.keys}"
        raise ArgumentError, errors
      end

      # fetch all params (optional and mandatory)
      check_params = method.parameters

      self.class.validate_ruleset(check_params, params)

    end

    #
    # This method validates a params hash against a specific rulset
    # @param valid_params ruleset
    # @param params
    #
    def Validator.validate_ruleset(valid_params, params)
      errors = []
      if !valid_params.nil? and params.nil?
        errors.push "Nil parameters when #{valid_params.length} expected"
        raise ArgumentError, errors
      end

      # if just one param -> include as array with length 1
      if valid_params.instance_of?(Array) && valid_params.length == 1 && params.instance_of?(String)
        params = {valid_params[0].name.to_sym => params}
      end

      # Validate the params
      valid_params.each{|key|
        # get param
        param = params[key.name.to_sym]
        check_result = Validator.check_param(key, param)
        unless check_result.nil?
          errors.push check_result
        end
      }
      unless errors.empty?
        raise ArgumentError, errors
      end
      # no exception -> successfully validated
      true

    end

    #
    # This method validates if the specific method is valid
    # @param valid_param object containing the param ruleset
    # @param param param specified by the user in the method call
    #
    def Validator.check_param(valid_param, param)
      if valid_param.optional? and param.nil? # argument optional and not present -> continue
        return nil
      end

      if param.nil? # argument mandatory and not present
        return ERROR_MESSAGE_NULL % valid_param.name
      else
        # check argument type is valid
        unless param.is_a?(valid_param.klass)
          return ERROR_MESSAGE_TYPE % [valid_param.name, param.class]
        end

        # check argument satisfies ruleset (if present)
        unless valid_param.rule.nil?
          !valid_param.rule.call(param) and return ERROR_MESSAGE_BLOCK % valid_param.name
        end
      end
      nil
    end

  end
end
