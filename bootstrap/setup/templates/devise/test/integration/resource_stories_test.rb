require 'test_helper'

<% singular = @resource.singularize -%>
class <%= singular.camelize %>StoriesTest < ActionDispatch::IntegrationTest

  test "customer signs up with valid attributes" do

    assert_equal 0, ActionMailer::Base.deliveries.size
    
    get "/signup"
    assert_response :success
    
    post_via_redirect "/<%= @resource %>", :<%= singular %> => Factory.attributes_for(:<%= singular %>)
    assert_equal "/<%= singular %>", path
    
    assert_equal 1, ActionMailer::Base.deliveries.size
    
  end
  
  test "customer tries to access their /<%= singular %>/edit page without being authenticated" do
    
    <%= singular %> = Factory.create(:<%= singular %>)
  
    get_via_redirect "/<%= singular %>/edit"
    assert_equal "/<%= @resource %>/signin", path
    
    post_via_redirect "/<%= @resource %>/signin", :<%= singular %> => {:email => <%= singular %>.email, :password => <%= singular %>.password}
    assert_equal "/<%= singular %>/edit", path
  
    get_via_redirect "/signout"
    assert_equal "/", path
  
  end
  

end