module ParamsValidator

  #
  # Parameter definition
  #
  class Parameter

    # parameter name
    attr_accessor :name

    # set if parameter is mandatory or optional
    attr_accessor :optional

    # parameter type (Object by default)
    attr_accessor :klass

    # specific ruleset (i.e. max or min length)
    attr_accessor :rule

    def initialize(name, klass = Object, optional = false, rule = nil)
      @name = name.to_sym
      @optional = optional
      @klass = klass
      @rule = rule
    end

    def optional?
      @optional
    end

    def mandatory?
      !@optional
    end
  end
end
