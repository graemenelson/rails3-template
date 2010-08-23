require 'test_helper'
class Devise::PasswordsControllerTest < ActionController::TestCase
  
  context "routes" do

    should "/<%= @resource %>/password/new should route to {:controller => 'devise/passwords', :action => 'new'}" do
      assert_routing( "/<%= @resource %>/password/new", {:controller => 'devise/passwords', :action => 'new'})
    end     
        
  end
  
end