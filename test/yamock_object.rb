require 'params-validator'

class YamockObject
  include ParamsValidator::ValidParams

  METHODS = [:log, :log_level, :log_level_type, :log_level_type_optional, :log_data, :log_data_block]
  
  METHODS.each{|m|
    define_method(m) do |*args, &block|
      true
    end
  }

  validate_method METHODS
end

