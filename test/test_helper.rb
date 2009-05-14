require 'rubygems'
require 'active_support'
require 'active_support/test_case'
require 'shoulda'
require 'factory_girl'

$: << File.expand_path(File.dirname(__FILE__) + '/..')

ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/rails_app/config/environment")
require 'test_help'
require File.expand_path(File.dirname(__FILE__) + "/rails_app/test/factories/users")
require File.expand_path(File.dirname(__FILE__) + "/../app/models/user_authentication")

class ActiveSupport::TestCase
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false
end

# To speed-up tests by not iterating password hash 
PASSWORD_HASH_ITERATIONS = 1

