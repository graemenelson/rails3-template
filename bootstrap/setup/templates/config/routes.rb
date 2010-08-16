Rails3Shoulda::Application.routes.draw do
  devise_for :<%= @resource %>, :path_names => { :sign_in => 'signin', :sign_out => 'signout', :sign_up => 'signup' }
  as :<%= @resource.singularize %> do
    get "/signup" => "devise/registrations#new"
    get "/signin" => "devise/sessions#new"
    get "/signout" => "devise/sessions#destroy"
  end            
end