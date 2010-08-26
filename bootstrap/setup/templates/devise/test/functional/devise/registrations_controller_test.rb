require 'test_helper'

<% singular = @resource.singularize -%>
class Devise::RegistrationsControllerTest < ActionController::TestCase

  setup :fix_devise_registrations_authenticate_scope
  
  context "routes" do
        
    should route(:get, '/<%= @resource %>/signup').to(:controller => 'devise/registrations', :action => 'new')        
        
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
            assert_select "fieldset.inputs" do
              assert_select "ol" do
                assert_select "li#<%= singular %>_email_input.required" do
                  assert_select "label[for='<%= singular %>_email']", :text => "#{I18n.t('activerecord.attributes.<%= singular %>.email')}*"
                  assert_select "input[type='text'][name='<%= singular %>[email]']"                  
                end
                assert_select "li#<%= singular %>_password_input.required" do
                  assert_select "label[for='<%= singular %>_password']", :text => "#{I18n.t('activerecord.attributes.<%= singular %>.password')}*"
                  assert_select "input[type='password'][name='<%= singular %>[password]']"                  
                end
                assert_select "li#<%= singular %>_password_confirmation_input.optional" do
                  assert_select "label[for='<%= singular %>_password_confirmation']", :text => "#{I18n.t('activerecord.attributes.<%= singular %>.password_confirmation')}"
                  assert_select "input[type='password'][name='<%= singular %>[password_confirmation]']"                  
                end
              end
            end
            assert_select "fieldset.buttons" do
              assert_select "ol" do
                assert_select "li.commit" do
                  assert_select "input[type='submit'][value='Create #{<%= singular.titleize %>}']"
                end
              end
            end
          end
          assert_select "ul.devise-links" do
            assert_select "li" do
              assert_select "a[href='#{signin_path}']", :text => "Sign in"
            end
            assert_select "li" do
              assert_select "a[href='#{new_<%= singular %>_password_path}']", :text => "Forgot your password?"
            end
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
      
      should "render appropriate view elements" do
        assert_select "body#registrations.create" do
          assert_select "h2", :text => I18n.t('registrations.create.header')          
          assert_select "form[action='/<%= @resource %>']" do
            assert_select "div#error_explanation"
            assert_select "fieldset.inputs" do
              assert_select "ol" do
                assert_select "li#<%= singular %>_email_input.required" do
                  assert_select "label[for='<%= singular %>_email']", :text => "#{I18n.t('activerecord.attributes.<%= singular %>.email')}*"
                  assert_select "input[type='text'][name='<%= singular %>[email]']"                  
                  assert_select "p.inline-errors"
                end
                assert_select "li#<%= singular %>_password_input.required" do
                  assert_select "label[for='<%= singular %>_password']", :text => "#{I18n.t('activerecord.attributes.<%= singular %>.password')}*"
                  assert_select "input[type='password'][name='<%= singular %>[password]']"                  
                  assert_select "p.inline-errors"
                end
                assert_select "li#<%= singular %>_password_confirmation_input.optional" do
                  assert_select "label[for='<%= singular %>_password_confirmation']", :text => "#{I18n.t('activerecord.attributes.<%= singular %>.password_confirmation')}"
                  assert_select "input[type='password'][name='<%= singular %>[password_confirmation]']"                  
                end
              end
            end
            assert_select "fieldset.buttons" do
              assert_select "ol" do
                assert_select "li.commit" do
                  assert_select "input[type='submit'][value='Create #{<%= singular.titleize %>}']"
                end
              end
            end
          end
          assert_select "ul.devise-links" do
            assert_select "li" do
              assert_select "a[href='#{signin_path}']", :text => "Sign in"
            end
            assert_select "li" do
              assert_select "a[href='#{new_<%= singular %>_password_path}']", :text => "Forgot your password?"
            end
          end          
        end        
      end
      
    end
    
  end
  
  context "edit" do
  
    context "without authenticate <%= singular %>" do
    
      setup do
        get :edit
      end
      
      should redirect_to("new <%= singular %> session path") { new_<%= singular %>_session_path }
      
    end
  
    context "with authenticated <%= singular %>" do

      setup do
        sign_in Factory(:<%= singular %>)
        get :edit
      end

      should render_template(:edit)
      should render_with_layout(:application)
      
      should "render appropriate view elements" do
        assert_select "body#registrations.edit" do
          assert_select "h2", :text => I18n.t('registrations.edit.header')          
          assert_select "form[action='/<%= @resource %>']" do
            assert_select "fieldset.inputs" do
              assert_select "ol" do
                assert_select "li#<%= singular %>_email_input.required" do
                  assert_select "label[for='<%= singular %>_email']", :text => "#{I18n.t('activerecord.attributes.<%= singular %>.email')}*"
                  assert_select "input[type='text'][name='<%= singular %>[email]']"                  
                end
                assert_select "li#<%= singular %>_current_password_input.required" do
                  assert_select "label[for='<%= singular %>_current_password']", :text => "#{I18n.t('activerecord.attributes.<%= singular %>.current_password')}*"
                  assert_select "input[type='password'][name='<%= singular %>[current_password]']"                  
                end
                assert_select "li#<%= singular %>_password_input.optional" do
                  assert_select "label[for='<%= singular %>_password']", :text => "#{I18n.t('activerecord.attributes.<%= singular %>.password')}"
                  assert_select "input[type='password'][name='<%= singular %>[password]']"                  
                end
                assert_select "li#<%= singular %>_password_confirmation_input.optional" do
                  assert_select "label[for='<%= singular %>_password_confirmation']", :text => "#{I18n.t('activerecord.attributes.<%= singular %>.password_confirmation')}"
                  assert_select "input[type='password'][name='<%= singular %>[password_confirmation]']"                  
                end
              end
            end
            assert_select "fieldset.buttons" do
              assert_select "ol" do
                assert_select "li.commit" do
                  assert_select "input[type='submit'][value='Update #{<%= singular.titleize %>}']"
                end
              end
            end
          end
        end        
      end

    end
    
  end
  
  context "update" do 
    
    context "with valid attributes" do
    
      setup do
        @<%= singular %> = Factory.create(:<%= singular %>)
        sign_in( @<%= singular %> )
        put :update, :<%= singular %> => {:email => "updated-#{@<%= singular %>.email}", :current_password => @<%= singular %>.password }
      end
      
      should redirect_to("<%= singular %> path") { <%= singular %>_root_path }
      should set_the_flash.to(:notice => I18n.t('devise.registrations.updated'))
      
    end
    
    
    context "with invalid attributes" do
      
      
    end
    
  end

  
  private

  # this is to fix an issue with authenticate scope not working 
  # properly with non-authenticated <%= singular %>.  
  def fix_devise_registrations_authenticate_scope
    @controller.instance_eval do
      def authenticate_scope!
        send(:"authenticate_#{resource_name}!")
        current_resource = send(:"current_#{resource_name}")
        self.resource = resource_class.find(current_resource.id) if current_resource.present?
      end
    end
  end
  
end