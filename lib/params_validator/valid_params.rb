#
# Juan de Bravo <juandebravo@gmail.com>
#

module ParamsValidator

  #
  # Module to be included in a class which methods should be validated
  #
  module ValidParams

    def self.included(base)
      base.extend(ClassMethods)
    end

    #
    # This method is called to validate the request parameters to a specific method before calling the method itself
    # @param params Hash of parameters to validate
    # @param interface_method String containing the fully qualified method name (Module1::Module2::Class::method)
    #
    def previous_validation(params = nil, interface_method = nil)
      unless validator.nil?
        if interface_method.nil?
          interface = caller[0][/^(.*)(\.rb).*$/, 1].split('/').last
          interface = caller[0][/^(.*)(\.rb).*$/, 1].split('/')
          interface.shift
          interface = interface.map!{|x| x.capitalize}.join("::")
          method    = caller[0][/`([^']*)'/, 1]
          interface_method = [interface, method].join("::")
        else
          # Got directly the method name in interface_method
        end
        params.instance_of?(Array) and params = params[0]
        validator.validate_params(interface_method, params)
      end
    end

    def validator
      self.class.validator
    end

    def load_rules(rules)
      self.class.load_rules(rules)
    end

    # inner module to define class methods
    module ClassMethods

      # This method is used in classes to define which methods
      # should be validated when called.
      # i.e. validate_method :method1
      #      validate_method [:method1, :method2]
      def validate_method(method, &block)
        # get the fully qualified method name
        interface = caller[0][/^(.*)(\.rb).*$/, 1].split('/').last
        interface = caller[0][/^(.*)(\.rb).*$/, 1].split('/')
        interface.shift
        interface = interface.map!{|x| 
          unless x.index("_").nil?
            x = x.gsub(/_[a-zA-Z]/) {|s| s[1..-1].upcase}
          end
          x=x[0..0].upcase+x[1..-1]
        }.join("::")

        # cast to array if method is one symbol
        method.instance_of?(Symbol) and method = [method]

        # wrap each method
        method.each{|m|
          interface_method = [interface, m].join("::")

          # add validation rule to the specific method if a block is defined
          if block_given?
            validator.validation_rule(interface_method, &block)
          end

          # wrap old method with the previous validation
          old_method = "#{m}_old"
          self.send :alias_method, *[old_method, m]

          define_method(m) do |*args, &block|
            # validate parameters
            previous_validation(args, interface_method)
            # call method
            send(old_method, *args, &block)
          end
        }
      end

      # validator object
      def validator
        @@validator ||= Validator.new
      end

      # shortcut to validator.load_rules
      def load_rules(rules)
        validator.load_rules(rules)
      end

    end

  end
end
