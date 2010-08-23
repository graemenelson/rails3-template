require 'test_helper'

<% singular = @resource.singularize -%>
class Devise::RegistrationsControllerTest < ActionController::TestCase
  
  context "routes" do

    should "/<%= @resource %>/signup should route to {:controller => 'devise/registrations', :action => 'new'}" do
      assert_routing( "/<%= @resource %>/signup", {:controller => 'devise/registrations', :action => 'new'})
    end     
        
  end
  
  context "new" do
    
    context "without an authenticated <%= singular %>" do
      
      setup do
        get :new
      end
         
      should render_template(:new)

      should "render appropriate view elements" do
        assert_select "body#registrations.new" do
          assert_select "h2", :text => I18n.t('registrations.new.header')
          assert_select "form[action='/<%= @resource %>']" do
            assert_select "label[for='<%= singular %>_email']", :text => "#{I18n.t('activerecord.attributes.<%= singular %>.email')}*"
            assert_select "input[type='text'][name='<%= singular %>[email]']"
            assert_select "label[for='<%= singular %>_password']", :text => "#{I18n.t('activerecord.attributes.<%= singular %>.password')}*"
            assert_select "input[type='password'][name='<%= singular %>[password]']"
            assert_select "label[for='<%= singular %>_password_confirmation']", :text => "#{I18n.t('activerecord.attributes.<%= singular %>.password_confirmation')}"
            assert_select "input[type='password'][name='<%= singular %>[password_confirmation]']"
          end
        end        
      end      
    end
    
  end
  
  context "create" do
    
    context "with valid attributes" do
      
      setup do
        post :create, :<%= singular %> => Factory.attributes_for(:<%= singular %>)
      end
      
      should redirect_to("<%= singular %> path") { <%= singular %>_root_path }
      should set_the_flash.to(:notice => I18n.t('devise.registrations.signed_up'))
      
    end
    
    context "with invalid attributes" do
    
      setup do
        post :create, :<%= singular %> => {}
      end
      
      should render_template(:new)
      
    end
    
  end
  
  context "edit" do
  
    context "edit" do

      setup do
        sign_in Factory(:<%= singular %>)
        get :edit
      end

      should render_template(:edit)
      should render_with_layout(:application)
      
      should "render appropriate view elements" do
        assert_select "body#registrations.edit" do
          assert_select "h2", :text => I18n.t('registrations.edit.header')
        end        
      end

    end
    
  end
  
end