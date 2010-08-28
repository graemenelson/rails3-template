require 'test_helper'

<% singular = @resource.singularize -%>
class Devise::SessionsControllerTest < ActionController::TestCase
   
  context "new" do
  
    context "without an authenticated <%= singular %>" do
      
      setup do
        get :new
      end
      
      should render_template(:new)
      should render_with_layout(:public)
      
      should "render appropriate view elements" do
        assert_select "body#sessions.new" do
          assert_select "h2", :text => I18n.t('sessions.new.header')
          assert_select "form[action='#{new_<%= singular %>_session_path}']" do
            assert_select "fieldset.inputs" do
              assert_select "ol" do
                assert_select "li#<%= singular %>_email_input" do
                  assert_select "label[for='<%= singular %>_email']", :text => "#{I18n.t('activerecord.attributes.<%= singular %>.email')}*"
                  assert_select "input[type='text'][name='<%= singular %>[email]']"                  
                end
                assert_select "li#<%= singular %>_password_input" do
                  assert_select "label[for='<%= singular %>_password']", :text => "#{I18n.t('activerecord.attributes.<%= singular %>.password')}*"
                  assert_select "input[type='password'][name='<%= singular %>[password]']"                  
                end
              end
            end
            assert_select "fieldset.buttons" do
              assert_select "ol" do
                assert_select "li.commit" do
                  assert_select "input[type='submit'][value='#{I18n.t('sessions.new.buttons.commit')}']"
                end
              end              
            end
          end
        end        
      end
    end
    
    context "with an authenticated <%= singular %>" do
    
      setup do
        sign_in( Factory.create(:<%= singular %>) )
        get :new
      end
      
      should redirect_to("<%= singular %> path") { <%= singular %>_root_path }
            
    end
    
  end
  
  context "create" do
  
    context "with valid login credentials" do
    
      setup do
        <%= singular %> = Factory.create(:<%= singular %>)
        post :create, :<%= singular %> => {:email => <%= singular %>.email, :password => <%= singular %>.password}
      end
      
      should redirect_to("<%= singular %> path") { <%= singular %>_root_path }
      
    end
    
    context "with invalid login credentials" do
      
      setup do
        # TODO: need to get the TestWarden to actually handle the redirect
        # properly.  See TestWarden#catch_and_redirect should actually force
        # a redirect at this point, instead of setting render on the controller.
        @controller.stubs(:sign_in_and_redirect)
        post :create, :<%= singular %> => {:email => "", :password => ""}
      end
      
      should render_template(:new)
      
    end
    
  end
  
end