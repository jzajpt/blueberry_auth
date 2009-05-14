require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the blueberry_auth plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

namespace :test_app do
  desc 'Prepare testing environment.'
  task :generate do
    FileUtils.rm_rf "test/rails_app" if File.exists?('test/rails_app')
    system "cd test && rails rails_app && cd rails_app"
    FileUtils.mkdir_p 'test/rails_app/vendor/plugins/'
    root = File.dirname(__FILE__)
    system "ln -s #{root} test/rails_app/vendor/plugins/blueberry_auth"
    FileUtils.rm_rf "test/rails_app/test/performance"
    system "cd test/rails_app && script/generate blueberry_auth && rake db:migrate && rake db:test:prepare"
  end
end

desc 'Generate documentation for the blueberry_auth plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'BlueberryAuth'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
