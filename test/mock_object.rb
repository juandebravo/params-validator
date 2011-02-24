require 'params-validator'

class MockObject
  include ParamsValidator::ValidParams

  [:log, :log_level, :log_level_type, :log_level_type_optional, :log_data, :log_data_block].each{|m|
    define_method(m) do |*args, &block|
      #puts "call to method #{m.to_s}"
      true
    end
  }

  validate_method(:log) do
  end
  validate_method(:log_level) do
    level
  end
  validate_method(:log_level_type) do
    level Fixnum
  end
  validate_method(:log_level_type_optional) do
    level(Fixnum, :optional)
  end
  validate_method(:log_data) do
    data(String)
    level(Fixnum, :optional)
  end
  validate_method(:log_data_block) do
    data(String) { |data| !data.nil? and data.length > 0}
    level(Fixnum, :optional) {|level| level <= 3}
  end
end

