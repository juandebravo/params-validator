require 'params_validator/validator'

#
# Juan de Bravo <juandebravo@gmail.com>
#

module ParamsValidator
  #
  # Class used to enhance the way to pass parameters to a method
  #
  class Request < Hash

    def initialize(params = nil)
      super(params)
    end

    def add(key, value)
      self[key.to_sym] = value
      self
    end

    alias :delete_old :delete

    def delete(key)
      delete_old(key)
      self
    end

    def params
      keys
    end

    alias :size :length

    def validate(ruleset)
      ParamsValidator::Validator.validate_ruleset(ruleset, self)
    end

    def valid?(ruleset)
      begin
        validate(ruleset)
        true
      rescue
        false
      end
    end
  end
end