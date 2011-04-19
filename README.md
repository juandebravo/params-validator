# Introduction

 The aim of params-validator is to allow an easy way to validate the
parameters in a method call.

# Install

    gem install params-validator

# Requirements

# v0.2.0 changes

- FEATURE: definition of validation rulesets inside the method, so it improves the code style including the validation as the first step in a method execution (suggested by [osuka](https://github.com/osuka))

- FIXED: If a method has a ruleset that defines all the parameters as optional, a nil argument
	is allowed. On previous versions an ArgumentError exception was thrown
	
- FIXED: inheritance allowed. A method can define a more restrictive ruleset in a inherited method.

- FIXED: a method validation can be redefined, the first definition will not be used.
	
- MOVED: specs to folder ./spec

# Usage

* There are four ways of use:

  * Include validation rules inside the object:

  See this example:

		require 'params-validator'
		class MockObject
		  include ParamsValidator::ValidParams
		  # define two useless methods 
		  [:method1, :method2].each{|m|
		    define_method(m) do |*args, &block|
		      puts {:foo => "bar"}
		      true
		    end
		  }
		  # method1 arguments ruleset
		  validate_method(:method1) do
		    level(Fixnum, :optional)
		  end
		  # method2 arguments ruleset
		  validate_method(:method2) do
		    data(String) { |data| !data.nil? and data.length > 0}
		    level(Fixnum, :optional) {|level| level <= 3}
		  end
		end
		

   When calling a specific method, an ArgumentError exception will be raised if at least one parameter is invalid

        obj = MockObject.new
        obj.method1({:level => "1"})  # This will raise an ArgumentError exception because :level parameter type is invalid
        obj.method1({:level => 1})  # This will execute successfully the method call
        obj.method2({:level => 1})  # This will raise an ArgumentError exception because :data parameter is missing

  * Include validation rules outside the object:

        class MockObject
          include ParamsValidator::ValidParams
          # define two useless methods 
          [:method1, :method2].each{|m|
            define_method(m) do |*args, &block|
              true
            end
          }
          # method1 and method2 should be validated, but no ruleset is defined
          validate_method [:method1, :method2]
        end


  Then in a separate file, rulesets must be loaded:

        require 'params-validator'
        include ParamsValidator::ValidParams
        # define rulesets
        rules = <<EOF
          validation_rule("MockObject::method1") do
            level(Fixnum, :optional)
          end
          validation_rule("MockObject::method2") do
            data(String) { |data| !data.nil? and data.length > 0}
            level(Fixnum, :optional) {|level| level <= 3}
          end
        EOF
        # load rulesets in validation framework
        load_rules(rules)
        obj = MockObject.new
        obj.method1({:level => "1"})  # This will raise an ArgumentError exception because :level parameter type is invalid 
        obj.method1({:level => 1})  # This will execute successfully the method call
        obj.method2({:level => 1})  # This will raise an ArgumentError exception because :data parameter is missing

  * Implicit validation

    Ruleset defined inside the method, kudos to [osuka](https://github.com/osuka)

		require 'params-validator'
		class MockObject
		  include ParamsValidator::ValidParams
		
		  def method1(args)
		  	validate_method(args) do
		    	level(Fixnum, :optional)
		  	end
		  end
		end

  * Client side validation

    Request validation to ensure a method call is valid in advance, kudos to [drslump](https://github.com/drslump)

        obj = ParamsValidator::Request.new
        obj[:data] = "this is a log"
        obj[:level] = 1
        ruleset = MockObject.get_rule(:method2)
        obj.valid?(ruleset) # false
        begin
          obj.validate(ruleset)
        rescue ArgumentError => ae
          p ae.message  # array with validation errors
        end


  More examples can be found in test/spec folders.

