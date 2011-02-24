# Introduction

 The aim of params-validator is to allow an easy way to validate the
parameters in a method call.

# Install

    gem install params-validator

# Requirementes

# Usage

* There are two ways of use:

  * Include validation rules inside the object:

        require 'params-validator'
        class MockObject
          include ParamsValidator::ValidParams
          [:method1, :method2].each{|m|
            define_method(m) do |*args, &block|
              true
            end
          }
          validate_method(:method1) do
            level(Fixnum, :optional)
          end
          validate_method(:method2) do
            data(String) { |data| !data.nil? and data.length > 0}
            level(Fixnum, :optional) {|level| level <= 3}
          end
        end


  When calling a specific method, an ArgumentError exception will be raised if at least one parameter is invalid

        obj = MockObject.new
        obj.method1({:level => "1"})  # This will raise an ArgumentError exception because :level parameter type is invalid
        obj.method1({:level => 1})  # This will execute successfully the
        obj.method2({:level => 1})  # This will raise an ArgumentError exception because :data parameter is missing

  * Include validation rules outside the object:

        class MockObject
          include ParamsValidator::ValidParams
          [:method1, :method2].each{|m|
            define_method(m) do |*args, &block|
              true
            end
          }
          validate_method [:method1, :method2]
        end


  Then in a separate file, rulesets must be loaded:

        require 'params-validator'
        include ParamsValidator::ValidParams
        rules = <<EOF
          validation_rule("MockObject::method1") do
            level(Fixnum, :optional)
          end
          validation_rule("MockObject::method2") do
            data(String) { |data| !data.nil? and data.length > 0}
            level(Fixnum, :optional) {|level| level <= 3}
          end
        EOF
        obj = MockObject.new
        obj.method1({:level => "1"})  # This will raise an ArgumentError exception because :level parameter type is invalid 
        obj.method1({:level => 1})  # This will execute successfully the 
        obj.method2({:level => 1})  # This will raise an ArgumentError exception because :data parameter is missing


  More examples can be found in test folder.

