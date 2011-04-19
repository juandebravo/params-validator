require 'params-validator'
require 'mock/mock_object'

module Mock
  module MockSubmodule
    class MockObject < Mock::MockObject
      
      def log_new_method(params=nil)
        nil
      end

      validate_method(:log_new_method) do
        level(String, :optional)
      end
      
      def log_data(params)
        true
      end
      
      validate_method(:inherit_method) do
        level(Fixnum, :optional) {|level| level <= 3}
      end
    end
  end
end  
