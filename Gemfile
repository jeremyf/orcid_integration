source 'https://rubygems.org'

gem 'rails', '4.0.2'
gem 'sqlite3'
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 1.2'
gem 'thin'
gem 'devise'
gem 'omniauth-orcid', github: 'jeremyf/omniauth-orcid'
gem 'omniauth-github'
gem 'certified'
gem 'figaro'
gem 'foundation-rails'
gem 'simple_form'
gem 'byebug'
gem 'rest_client'
gem 'email_validator'
gem 'rails_layout'
group :debug do
  gem 'better_errors'
  gem 'binding_of_caller', :platforms=>[:mri_19, :mri_20, :rbx]
  gem 'guard-bundler'
  gem 'guard-rails'
  gem 'guard-rspec'
  gem 'quiet_assets'
  gem 'rb-fchange', :require=>false
  gem 'rb-fsevent', :require=>false
  gem 'rb-inotify', :require=>false
end
group :development, :test do
  gem 'factory_girl_rails'
  gem 'rspec-rails'
  gem 'rspec-html-matchers'
end
group :production do
  gem 'unicorn'
end
group :test do
  gem 'webmock', require: false
  gem 'capybara'
  gem 'database_cleaner', '1.0.1'
  gem 'email_spec'
end
