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
    # Rake::Task['spec:plugins'].invoke
  end

  plugin_directories = Dir['devise-multi_auth']
  namespace :plugins do
    plugin_directories.each do |plugin|
      component = plugin.sub('-', '_').to_sym
      desc "Run specs for #{plugin}"
      task component do
        Bundler.with_clean_env do
          FileUtils.cd(plugin)
          puts "\n*** Running plugin specs for #{plugin}"
          system("rspec")
          FileUtils.cd(File.expand_path('../', __FILE__))
        end
      end
    end
  end
  desc "Run specs for all plugins"
  task :plugins => plugin_directories.collect {|dir| "plugins:" << dir.gsub("-", '_') }
end
