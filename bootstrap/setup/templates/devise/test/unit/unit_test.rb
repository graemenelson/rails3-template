require 'test_helper'

<% klazz    = @resource.classify -%>
<% singular = @resource.singularize -%>
class <%= klazz %>Test < ActiveSupport::TestCase
  
  context "validation" do
    
    setup do
      @<%= singular %> = Factory(:<%= singular %>)
    end
    
    should validate_presence_of(:email)
    should validate_uniqueness_of(:email)
    should validate_presence_of(:password)

    should "require password and password_confirmation are the same" do
      @<%= singular %>.password_confirmation = ""
      assert !@<%= singular %>.valid?
    end
    
  end
  
  context "mass assignment" do
    
    should allow_mass_assignment_of(:email)
    should allow_mass_assignment_of(:password)
    should allow_mass_assignment_of(:password_confirmation)
    should allow_mass_assignment_of(:remember_me)
    
  end
  
end