$:.unshift File.join(File.dirname(__FILE__),'.')

require 'params-validator'
require 'mock/mock_object'
require 'yamock_object'

include Mock

describe ParamsValidator::ValidParams do
  describe "validate_method inside class" do
    it "executes an empty block and validates true always" do
      obj = MockObject.new
      obj.log({}).should eq(true)
    end

    it "raises an exception if mandatory parameter missing" do
      obj = MockObject.new
      lambda{obj.log_level({})}.should raise_error(ArgumentError)
    end

    it "raises an exception if mandatory parameter included but invalid type" do
      obj = MockObject.new
      lambda{obj.log_level_type({:level => "INFO"})}.should raise_error(ArgumentError)
    end

    it "raises an exception if optional parameter included but invalid type" do
      obj = MockObject.new
      lambda{obj.log_level_type_optional({:level => "INFO"})}.should raise_error(ArgumentError)
    end

    it "executes a valid ruleset with mandatory parameters" do
      obj = MockObject.new
      obj.log_level_type({:level => 3}).should eq(true)
    end

    it "executes a valid ruleset with mandatory and optional parameters included" do
      obj = MockObject.new
      obj.log_data({:level => 3, :data => "This is a test"}).should eq(true)
    end

    it "executes a valid ruleset with mandatory parameters included and optional parameters missing" do
      obj = MockObject.new
      obj.log_data({:data => "This is a test"}).should eq(true)
    end

    it "executes a valid ruleset with validation block for parameters" do
      obj = MockObject.new
      obj.log_data_block({:data => "This is a test", :level => 1}).should eq(true)
    end

    it "executes a valid ruleset with invalid validation block for mandatory parameter" do
      obj = MockObject.new
      lambda{obj.log_data_block({:data => ""})}.should raise_error(ArgumentError)
    end

    it "executes a valid ruleset with invalid validation block for optional parameter" do
      obj = MockObject.new
      lambda{obj.log_data_block({:data => "", :level => 5})}.should raise_error(ArgumentError)
    end
  end

  describe "validate_method inline" do
    rules = <<EOF
      validation_rule("YamockObject::log") do
      end
      validation_rule("YamockObject::log_level") do
        level
      end 
      validation_rule("YamockObject::log_level_type") do
        level Fixnum
      end 
      validation_rule("YamockObject::log_level_type_optional") do
        level(Fixnum, :optional)
      end 
      validation_rule("YamockObject::log_data") do
        data(String)
        level(Fixnum, :optional)
      end 
      validation_rule("YamockObject::log_data_block") do
        data(String) { |data| !data.nil? and data.length > 0}
        level(Fixnum, :optional) {|level| level <= 3}
      end 

EOF

    include ParamsValidator::ValidParams
    load_rules(rules)

    it "executes a valid ruleset with invalid validation block for optional parameter" do
      obj = YamockObject.new
      lambda{obj.log_data_block({:data => "", :level => 5})}.should raise_error(ArgumentError)
    end
    it "executes a valid ruleset with valid validation blocks" do
      obj = YamockObject.new
      obj.log_data_block({:data => "info", :level => 2}).should eq(true)
    end
  end

end
