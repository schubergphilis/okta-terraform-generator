require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

ENV['OKTA_TEST_USER_GROUP'] = 'github_users'
ENV['OKTA_TEST_ADMIN_GROUP'] = 'github_admins'

RSpec::Core::RakeTask.new(:spec)

task default: :spec
