require 'test_helper'
<% singular = @resource.singularize -%>
class Devise::PasswordsControllerTest < ActionController::TestCase
  
  context "new" do
    
    context "without an authenticated <%= singular %>" do
      
      setup do
        get :new
      end
      
      should render_template(:new)
      should render_with_layout(:public)
      
      should "render appropriate view elements" do
        assert_select "body" do
          assert_select "h2", :text => I18n.t('passwords.new.header')
          assert_select "form[action='#{<%= singular %>_password_path}']" do
            assert_select "fieldset.inputs" do
              assert_select "ol" do
                assert_select "li#<%= singular %>_email_input" do
                  assert_select "label[for='<%= singular %>_email']", :text => "#{I18n.t('activerecord.attributes.<%= singular %>.email')}*"
                  assert_select "input[type='text'][name='<%= singular %>[email]']"                  
                end
              end
            end
            assert_select "fieldset.buttons" do
              assert_select "ol" do
                assert_select "li.commit" do
                  assert_select "input[type='submit'][value='#{I18n.t('passwords.new.buttons.commit')}']"
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

     context "with valid email address" do
       
       setup do
         @<%= singular %> = Factory.create(:<%= singular %>)
         ActionMailer::Base.deliveries.clear
         post :create, :<%= singular %> => {:email => @<%= singular %>.email} 
       end

       should "send reset password email" do
         assert_equal 1, ActionMailer::Base.deliveries.size
       end
       
       should "set reset password token" do
         assert_not_nil @<%= singular %>.reload.reset_password_token
       end

     end

     context "without a valid email address" do
       
       setup do
         @<%= singular %> = Factory.create(:<%= singular %>)
         ActionMailer::Base.deliveries.clear
         post :create, :<%= singular %> => {:email => ""}         
       end

       should render_template(:new)

     end

   end

   context "edit" do

     context "with token" do 
       
       setup do
         reset_password_token = "myspecialtoken"
         @<%= singular %> = Factory.create(:<%= singular %>)
         @<%= singular %>.update_attribute(:reset_password_token, reset_password_token)
         get :edit, :reset_password_token => reset_password_token
       end

       should render_template(:edit)
       should render_with_layout(:application)
       
       should "render appropriate view elements" do
         assert_select "body" do
           assert_select "h2", :text => I18n.t('passwords.edit.header')
           assert_select "form[action='#{<%= singular %>_password_path}']" do
             assert_select "fieldset.inputs" do
               assert_select "ol" do
                 assert_select "li#<%= singular %>_reset_password_token_input.hidden" do
                   assert_select "input[type='hidden'][name='<%= singular %>[reset_password_token]']"
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
                   assert_select "input[type='submit'][value='#{I18n.t('passwords.edit.buttons.commit')}']"
                 end
               end              
             end             
           end
         end         
       end   

     end

   end

   context "update" do
     
     setup do
       @<%= singular %> = Factory.create(:<%= singular %>)
       @<%= singular %>.update_attribute(:reset_password_token, "secrettoken")
       @current_encrypted_password = @<%= singular %>.encrypted_password
     end

     context "with valid password and password confirmation" do
       
       setup do
         put :update, :<%= singular %> => {:reset_password_token => @<%= singular %>.reset_password_token, :password => "mynewpassword", :password_confirmation => "mynewpassword"}
       end

       should "change password" do
         assert_not_equal @current_encrypted_password, @<%= singular %>.reload.encrypted_password
       end
       
       should redirect_to( "<%= singular %> root path" ) { <%= singular %>_root_path }

     end

     context "with invalid password and password confirmation" do
       
       setup do
         put :update, :<%= singular %> => {:reset_password_token => @<%= singular %>.reset_password_token, :password => "mynewpassword", :password_confirmation => "blah"}
       end
       
       should render_template(:edit)
       should render_with_layout(:application)

     end
     
     context "with invalid reset password token" do
       
       setup do
         put :update, :<%= singular %> => {:reset_password_token => "", :password => "mynewpassword", :password_confirmation => "mynewpassword"}         
       end
     
       should render_template(:edit)
       should render_with_layout(:application)
       
     end

   end

  
end