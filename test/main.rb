$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'params-validator'
require 'project/provisioning/user_object'
require 'project/provisioning/application'

if __FILE__ == $0
  rules = <<EOF
    validation_rule "Project::Provisioning::UserObject::create" do
      name (String) {|value| value.length > 5 && value.length < 10}
      password String
      birthday (Fixnum) {|value| Time.now.year > value}
      description(String, :optional) {|value| value.length > 50 && value.length < 100}
    end

    validation_rule "Project::Provisioning::UserObject::delete" do
      user_id (String)
    end
EOF

  include ParamsValidator::ValidParams

  load_rules(rules)


  user = Project::Provisioning::UserObject.new
  user.create({:name => "juannnnn", :password => "project", :birthday => 1978})
  user.delete({:user_id => "juan"})

  application = Project::Provisioning::Application.new
  application.create({:user_id => "juan"})

  application.delete({:app_id => "app1"})

end
