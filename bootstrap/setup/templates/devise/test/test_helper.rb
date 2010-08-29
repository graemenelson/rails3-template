ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

ActionController::TestCase.send :include, Devise::TestHelpers
ActionController::TestCase.class_eval do
  setup do
    @request.env["devise.mapping"] = Devise.mappings[:<%= @resource.singularize %>]
  end
end