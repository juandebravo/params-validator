require 'params-validator'

module Project
  module Provisioning
    class UserObject
      include ParamsValidator::ValidParams

      def create(params)
        puts "create a specific user"
      end

      def delete(params)
        puts "delete a specific user"
      end

      validate_method [:delete, :create]

    end
  end
end
