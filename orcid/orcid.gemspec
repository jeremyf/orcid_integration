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
  s.add_dependency 'mappy', '~> 0.1.0'
  s.add_dependency 'devise-multi_auth', '~> 0.0.3'
  s.add_dependency 'omniauth-orcid'

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "engine_cart"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "database_cleaner"
  s.add_development_dependency "factory_girl"
end
