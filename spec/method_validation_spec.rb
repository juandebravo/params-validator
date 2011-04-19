require 'params-validator'

describe ParamsValidator::MethodValidation  do
  describe "method_name" do
    it "method_name returns the valid method name" do
      method = ParamsValidator::MethodValidation.new("method_name")
      method.method_name.should == "method_name"
    end
    it "method_name with module/class returns the valid method name" do
      method = ParamsValidator::MethodValidation.new("Module1::Module2::Class::method")
      method.method_name.should eq("Module1::Module2::Class::method")
    end
  end

  describe "parameters" do
    proc = lambda{
      name(String) {|value| value.length > 5 && value.length < 10}
      password
      birthday(Fixnum) {|value| Time.now.year > value}
      description(String, :optional) {|value| value.length > 50 && value.length < 100}
    }

    it "params length should be 4" do
      method = ParamsValidator::MethodValidation.new("Module::Class:method")
      method.block &proc
      method.parameters.length.should == 4
    end

    it "mandatory params length should be 3" do
      method = ParamsValidator::MethodValidation.new("Module::Class:method", &proc)
      method.parameters.length.should == 4
    end

    it "default object should be Object" do
      method = ParamsValidator::MethodValidation.new("Module::Class:method", &proc)
      method.parameters[1].klass.should == Object
    end

    it "parameter with ruleset should have rule attribute" do
      method = ParamsValidator::MethodValidation.new("Module::Class:method", &proc)
      method.parameters[0].rule.should_not == nil
    end

    it "parameter without ruleset should have nil rule attribute" do
      method = ParamsValidator::MethodValidation.new("Module::Class:method", &proc)
      method.parameters[1].rule.should == nil
    end
  end

end
