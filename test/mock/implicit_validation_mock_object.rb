require 'params-validator'

module Mock
  class ImplicitValidationMockObject
    include ParamsValidator::ValidParams

    def log_implicit_validation(args=nil)
    end

    def log_implicit_validation_one_arg(args)
      validate_method(args) do
        level Fixnum  
      end
    end

    def log_implicit_validation_one_optional_arg(args={})
      validate_method(args) do
        level(Fixnum, :optional)
      end
      nil
    end

    def log_implicit_validation_two_args(args=nil)
      validate_method(args) do
        data(String, :optional) { |data| !data.nil? and data.length > 0}
        level(Fixnum, :optional)
      end
      nil
    end
  end
end  
