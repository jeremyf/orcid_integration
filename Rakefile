# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

OrcidIntegration::Application.load_tasks

task :ci do
  ENV['RAILS_ENV'] = 'ci'
  Rails.env = 'ci'
  Rake::Task['spec'].invoke
end
