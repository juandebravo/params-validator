$:.unshift File.join(File.dirname(__FILE__),'../test')

require 'params-validator'
require 'mock/mock_submodule/mock_object'

include Mock::MockSubmodule

describe ParamsValidator::Validator do
  describe "new defined method" do
    it "works with a new defined method with no arguments" do
      obj = MockObject.new
      obj.log_new_method().should eq(nil)
    end

    it "works with a new defined method with one argument" do
      obj = MockObject.new
      obj.log_new_method({:level => "2"}).should eq(nil)
    end

    it "raises an exception with a new defined method one invalid argument" do
      obj = MockObject.new
      lambda{obj.log_new_method({:level => 2})}.should raise_exception(ArgumentError)
    end    
  end

  describe "ruleset inheritance" do
    it "works with a inherited ruleset with valid arguments" do
      obj = MockObject.new
      obj.log_data_block({:level => 1, :data => "foo"}).should eq(true)
    end

    it "raises an exception with an inherited ruleset with invalid data" do
      obj = MockObject.new
      lambda{obj.log_new_method({:level => 2})}.should raise_exception(ArgumentError)
    end    
  end
  
  describe "ruleset overwritten" do
    it "works when child ruleset changed and valid params" do
      obj = Mock::MockObject.new
      obj.inherit_method({:level => 1}).should eq(true)
    end

    it "works when child ruleset changed and invalid params" do
      obj = Mock::MockObject.new
      lambda{obj.inherit_method({:level => "6"})}.should raise_exception(ArgumentError)
    end

  end
  

end
