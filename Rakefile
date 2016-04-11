# frozen_string_literal: true

require "bundler/setup"
require "rake/testtask"
require "rubocop/rake_task"

task default: :test

Rake::TestTask.new do |t|
  t.pattern = "test/*_test.rb"
  t.warning = true
end

RuboCop::RakeTask.new do |task|
  task.options = ["--fail-level", "E"]
end
