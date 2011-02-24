$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'params-validator'

describe ParamsValidator::Parameter  do
  describe "optional" do
    #optional
    it "optional? returns true if parameter is optional" do
      param = ParamsValidator::Parameter.new("parameter", Object, true, nil)
      param.optional?.should == true
    end
    it "optional? returns false if parameter is mandatory" do
      param = ParamsValidator::Parameter.new("parameter", Object, false, nil)
      param.optional?.should == false
    end
  end

  describe "ruleset" do
    # ruleset
    it "rule returns nil if parameter has no ruleset defined" do
      param = ParamsValidator::Parameter.new("parameter", Object, false, nil)
      param.rule.should == nil
    end
  end

  describe "klass" do
    # klass
    it "klass returns parameter class if defined" do
      param = ParamsValidator::Parameter.new("parameter", String)
      param.klass.should == String
    end
    it "klass returns Object class if undefined" do
      param = ParamsValidator::Parameter.new("parameter")
      param.klass.should == Object
    end
  end
end
