# -*- encoding: utf-8 -*-
$:.push File.expand_path("lib", ".")

require "params_validator/version"

Gem::Specification.new do |s|
  s.name        = "params-validator"
  s.version     = ParamsValidator::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Juan de Bravo"]
  s.email       = ["juandebravo@gmail.com"]
  s.homepage    = ""
  s.summary     = "params-validators allows to validate the required/optional parameters in a method"
  s.description = "params-validators allows to validate the required/optional parameters in a method"

  s.rubyforge_project = "params-validator"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
end
