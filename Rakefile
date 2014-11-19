require 'bundler/gem_tasks'

namespace :test do
  task :prepare do
    mkdir 'spec/output'
  end

  task :cleanup do
    `rm -rf spec/output`
  end
end
