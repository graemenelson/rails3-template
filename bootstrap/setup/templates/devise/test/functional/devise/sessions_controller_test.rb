require 'test_helper'

<% singular = @resource.singularize -%>
class Devise::SessionsControllerTest < ActionController::TestCase
  
  context "routes" do

    should "/<%= @resource %>/signin should route to {:controller => 'devise/sessions', :action => 'new'}" do
      assert_routing( "/<%= @resource %>/signin", {:controller => 'devise/sessions', :action => 'new'})
    end     
        
  end
  
  context "new" do
  
    context "without an authenticated <%= singular %>" do
      
      setup do
        get :new
      end
      
      should render_template( :new )
      
    end
    
  end
  
end