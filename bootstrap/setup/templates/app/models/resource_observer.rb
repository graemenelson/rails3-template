<% singular = @resource.singularize -%>
class <%= singular.camelize %>Observer < ActiveRecord::Observer
  
  observe <%= singular.camelize %>
  
  def after_create(<%= singular %>)
    <%= singular.camelize %>Mailer.welcome(<%= singular %>).deliver
  end
  
end