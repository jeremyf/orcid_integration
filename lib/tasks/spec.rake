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
end
