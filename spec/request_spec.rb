$:.unshift File.join(File.dirname(__FILE__),'../test')

require 'params-validator'
require 'mock/mock_object'
require 'yamock_object'


describe ParamsValidator::Request do
  describe "handle parameters" do

    it "add any parameter" do
      obj = ParamsValidator::Request.new
      obj.add(:foo, "bar")
      obj.add(:length, 3)
      obj.size.should eq(2)
    end

    it "delete any parameter" do
      obj = ParamsValidator::Request.new
      obj.add(:foo, "bar")
      obj.add(:length, 3)
      obj.delete(:length)
      obj.size.should eq(1)
    end
  end

  describe "validate parameters" do

    it "validation return true with valid parameters" do
      obj = ParamsValidator::Request.new
      obj[:data] = "this is a log"
      obj[:level] = 1
      ruleset = Mock::MockObject.get_rule(:log_data_block)
      obj.validate(ruleset).should eq(true)
    end

    it "validation throw exception with invalid parameters" do
      obj = ParamsValidator::Request.new
      obj[:data] = "this is a log"
      obj[:level] = "1"
      ruleset = Mock::MockObject.get_rule(:log_data_block)
      lambda{obj.validate(ruleset)}.should raise_error(ArgumentError)
    end

    it "validation throw exception with the correct number of errors" do
      obj = ParamsValidator::Request.new
      obj[:data] = ""
      obj[:level] = "1"
      ruleset = Mock::MockObject.get_rule(:log_data_block)
      begin
        obj.validate(ruleset)
      rescue ArgumentError => ae
        ae.message.length.should eq(2)
      end
    end

  end

  describe "valid? method" do

    it "returns true if valid" do
      obj = ParamsValidator::Request.new
      obj[:data] = "this is a log"
      obj[:level] = 1
      ruleset = Mock::MockObject.get_rule(:log_data_block)
      obj.valid?(ruleset).should eq(true)
    end

    it "returns false if invalid" do
      obj = ParamsValidator::Request.new
      obj[:data] = "this is a log"
      obj[:level] = "1"
      ruleset = Mock::MockObject.get_rule(:log_data_block)
      obj.valid?(ruleset).should eq(false)
    end

  end

end
