$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "devise/multi_auth/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "devise-multi_auth"
  s.version     = DeviseMultiAuth::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of DeviseMultiAuth."
  s.description = "TODO: Description of DeviseMultiAuth."

  s.files = Dir["{app,config,db,lib}/**/*", "LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 4.0.3"

  s.add_development_dependency "sqlite3"
end
