require 'rspec/core/rake_task'

namespace :spec do
  desc 'Only run specs that do not require net connect'
  RSpec::Core::RakeTask.new(:offline) do |t|
    t.rspec_opts = "--tag ~requires_net_connect"
  end

  desc 'Only run specs that require net connect'
  RSpec::Core::RakeTask.new(:online) do |t|
    t.rspec_opts = "--tag requires_net_connect"
  end

  desc 'Run the Travis CI specs'
  task :travis do
    ENV['RAILS_ENV'] = 'travis'
    ENV['SPEC_OPTS'] = "--profile 20"
    Rails.env = 'travis'
    Rake::Task['db:create'].invoke
    Rake::Task['db:schema:load'].invoke
    Rake::Task['spec:offline'].invoke
  end
end
