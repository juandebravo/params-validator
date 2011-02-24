require 'params-validator'

module Project::Provisioning
  class Application
    include ParamsValidator::ValidParams

    def create(params)
      puts "create a specific #{self.class.name}"
    end

    def delete(params)
      puts "delete a specific #{self.class.name}"
    end

    rules = <<EOF
      validation_rule "Project::Provisioning::Application::create" do
        user_id (String)
      end
EOF

    load_rules(rules)


    validate_method :create

    validate_method(:delete) {
      app_id (String)
    }
    
  end
end
