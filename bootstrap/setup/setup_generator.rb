require 'generators/bootstrap'

module Bootstrap
  module Generators
    class SetupGenerator < Base
      desc "Description:\n  Sets up the initial application with devise as the underlying authentication system."
      class_option :email,    :type => :string, :default => "admin@site.com", :desc => "The initial admin account email"
      class_option :password, :type => :string, :default => "password", :desc => "The initial admin account password"      
                                 
      def setup_devise
        # install other packages we need
        generate "devise:install", "installing devise"
        generate "devise #{name}"        
        generate "formtastic:install"
        
        resource = name.tableize
                
        # TODO: need to add a root path, for admin it should go to dashboard???
        # see: http://wiki.github.com/plataformatec/devise/howto-redirect-to-a-specific-page-on-successful-sign-in
        route = %Q{
          Rails3Shoulda::Application.routes.draw do
            devise_for :#{resource}, :path_names => { :sign_in => 'signin', :sign_out => 'signout', :sign_up => 'signup' }
            as :#{resource.singularize} do
              get "/signup" => "devise/registrations#new"
              get "/signin" => "devise/sessions#new"
              get "/signout" => "devise/sessions#destroy"
            end            
          end          
        }
        
        remove_file "config/routes.rb"
        create_file "config/routes.rb", route
                                           
        # devise forms with formtastic support.
        run "cp -r #{self.class.source_root}/devise #{Rails.root}/app/views/"
        
        rake "db:migrate"

        # create initial admin account
        # TODO: need to add super_user/admin role, after we add CanCan
        email     = options[:email]
        password  = options[:password]
        admin = "Account.create!(:email => '#{email}', :password => '#{password}', :password_confirmation => '#{password}')"
        run "rails runner \"#{admin}\""
        

        # TODO: update other devise templates to use Formtastic
        # TODO: setup i18n file for Formtastic                 
        

        
        #rake "test"
      end
      
      def self.banner
        "rails generate bootstrap:#{generator_name} <account_class_name> [options]"
      end
      
    end
  end
end