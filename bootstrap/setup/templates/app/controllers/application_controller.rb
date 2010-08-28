class ApplicationController < ActionController::Base
  
  layout proc{ |controller| controller.devise_controller? ? devise_layout : "application" }
  
  protect_from_forgery
  
  private
  
  def devise_layout 
    devise_layout = "public"
    devise_layout = "application" if devise_actions_for_application_layout.include?( "#{controller_path}##{action_name}" )
    devise_layout
  end                                                                    
  
  def devise_actions_for_application_layout
    @_devise_actions_for_application_layout ||= 
      [ "devise/registrations#edit", 
        "devise/registrations#update", 
        "devise/passwords#edit", 
        "devise/passwords#update" ]
  end                                                                
  
end