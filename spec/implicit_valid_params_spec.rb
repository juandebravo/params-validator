$:.unshift File.join(File.dirname(__FILE__),'../test')

require 'params-validator'
require 'mock/implicit_validation_mock_object'
require 'yamock_object'

include Mock

describe ParamsValidator::ValidParams do

  let(:obj) do
    ImplicitValidationMockObject.new
  end

  describe "validate_method inside method (implicit definition)" do
    
    it "executes an empty block and validates true always" do
      obj.log_implicit_validation().should eq(nil)
    end
    
    it "executes an empty block and validates true if arguments defined" do
      obj.log_implicit_validation({:level => 1}).should eq(nil)
    end
    
    it "raises an exception if mandatory parameter missing" do
      lambda{obj.log_implicit_validation_one_arg()}.should raise_error(ArgumentError)
    end
    
    it "raises an exception if invalid type" do
      lambda{obj.log_implicit_validation_one_arg({:level => "1"})}.should raise_error(ArgumentError)
    end

    it "raises an exception if invalid type (II)" do
      lambda{obj.log_implicit_validation_one_arg({:level => 1.2})}.should raise_error(ArgumentError)
    end
    
    it "works if optional attr missing" do
      obj.log_implicit_validation_one_optional_arg({}).should eq(nil)
    end
    
    it "works if optional attr missing (nil arguments object)" do
      obj.log_implicit_validation_one_optional_arg(nil).should eq(nil)
    end        
  end
  
  describe "arguments that validates against a block" do

    it "works when the argument fits the block" do
      obj.log_implicit_validation_two_args(:level => 1, :data => "foo").should eq(nil)
    end
    
    it "works when the argument fits the block and one optional argument is not provided" do
      obj.log_implicit_validation_two_args(:data => "foo").should eq(nil)
    end
    
    it "works when the argument fits the block and both optional arguments is not provided" do
      obj.log_implicit_validation_two_args().should eq(nil)
    end

    it "raises an exception when argument not fit the block" do
      lambda{obj.log_implicit_validation_two_args({:data => ""})}.should raise_error(ArgumentError)
    end
  end

end
