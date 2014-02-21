$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "orcid/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "orcid"
  s.version     = Orcid::VERSION
  s.authors     = ["Jeremy Friesen"]
  s.email       = ["jeremy.n.friesen@gmail.com"]
  s.homepage    = "https://github.com/jeremyf/orcid_integration"
  s.summary     = "A Rails engine for orcid.org integration."
  s.description = "A Rails engine for orcid.org integration."

  s.files = Dir["{app,config,db,lib}/**/*", "LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 4.0.3"

  s.add_development_dependency "sqlite3"
end
