require 'generators/bootstrap'

module Bootstrap
  module Generators
    class SetupGenerator < Base
      desc "Description:\n  Sets up the initial application with devise as the underlying authentication system."
                                 
      def install
        @resource = name.tableize
        install_other_packages
        setup_initial_configuration
        setup_initial_tests
        setup_initial_application
        setup_initial_public
        overwrite_devise_settings                  

next_steps = <<-NEXTSTEPS                                             

======================================================================
Congratulations, your new app is all setup.  To start the server, run:

% rails s                                                            

Enjoy!
=======================================================================

NEXTSTEPS

        log next_steps
      end
      
      def self.banner
        "rails generate bootstrap:#{generator_name} <account_class_name>"
      end
      
      private
      
      # installs other library/gems
      def install_other_packages
        generate "devise:install", "installing devise"
        generate "devise #{name}"        
        generate "formtastic:install"  
      end  
      
      # setups the initial configuration files, such as routes and locales
      # see templates/config/routes.rb
      def setup_initial_configuration
        gsub_file "#{Rails.root}/config/routes.rb", "devise_for :#{@resource}", ""
        
routeconfig = <<-ROUTECONFIG

  devise_for :#{@resource}, :path_names => { :sign_in => 'signin', :sign_out => 'signout', :sign_up => 'signup' }
  as :#{@resource.singularize} do
    get "/signup" => "devise/registrations#new"
    get "/signin" => "devise/sessions#new"
    get "/signout" => "devise/sessions#destroy"
    get "/#{@resource.singularize}/edit" => "devise/registrations#edit"
    get "/" => "devise/sessions#new"    
  end

  # the default #{@resource.singularize} root path used by devise.
  match '/#{@resource.singularize}', :to => "#{@resource}#show", :as => "#{@resource.singularize}_root"

  # makes the / path redirect to devise signin page
  root :to => 'devise/sessions#new'   
ROUTECONFIG
        
        route routeconfig
                
        remove_file "#{Rails.root}/config/locales/en.yml"
        
        template "config/locales/defaults/en.yml", "config/locales/defaults/en.yml"
        template "config/locales/models/en.yml", "config/locales/models/en.yml"
        template "config/locales/views/en.yml", "config/locales/views/en.yml"
        
        run "mkdir #{Rails.root}/config/locales/devise"
        run "mv #{Rails.root}/config/locales/devise.en.yml #{Rails.root}/config/locales/devise/en.yml"
      end  
      
      # setups the initial tests, basic test to validate
      # that devise was setup properly.
      def setup_initial_tests
        remove_file "test/unit/#{@resource.singularize}_test.rb"
        template "devise/test/unit/unit_test.rb", "test/unit/#{@resource.singularize}_test.rb"
        remove_file "test/factories/#{@resource}.rb"
        template "devise/test/factories/factory.rb", "test/factories/#{@resource}.rb"
        
        Dir["#{self.class.source_root}/devise/test/functional/devise/*"].each do |filepath|
          filename = filepath.split("/").last
          template "devise/test/functional/devise/#{filename}", "test/functional/devise/#{filename}"
        end
        
        template "devise/test/integration/resource_stories_test.rb", "test/integration/#{@resource.singularize}_stories_test.rb"
        
        remove_file "test/test_helper.rb"
        template "devise/test/test_helper.rb", "test/test_helper.rb"
      end
      
      # setups the initial application, this includes moving over default
      # views and support classes.
      def setup_initial_application         
        remove_file "#{Rails.root}/app/controllers/application_controller.rb"
        template "app/controllers/application_controller.rb", "app/controllers/application_controller.rb"
        remove_file "#{Rails.root}/app/helpers/application_helper.rb"
        template "app/helpers/application_helper.rb", "app/helpers/application_helper.rb"
                                                                                        
        run "mkdir #{Rails.root}/app/mailers"
        
        template "app/controllers/resources_controller.rb", "app/controllers/#{@resource}_controller.rb"
        template "app/views/resources/show.html.haml", "app/views/#{@resource}/show.html.haml"
        template "app/models/resource_observer.rb", "app/models/#{@resource.singularize}_observer.rb"
        template "app/helpers/resources_helper.rb", "app/helpers/#{@resource}_helper.rb"      
        template "app/mailers/resource_mailer.rb", "app/mailers/#{@resource.singularize}_mailer.rb"
        template "app/views/resource_mailer/welcome.html.haml", "app/views/#{@resource.singularize}_mailer/welcome.html.haml"
        
        %w( application public ).each do |layout|
          remove_file "#{Rails.root}/app/views/layouts/#{layout}.html.haml"
          template "app/views/layouts/#{layout}.html.haml", "app/views/layouts/#{layout}.html.haml"
        end

app_config = <<-APPCONFIG
  
    # add an observer for the #{@resource.singularize.camelize} model
    config.active_record.observers = :#{@resource.singularize}_observer

    # default url options for action mailer, overwrite this in the production environment
    config.action_mailer.default_url_options = { :host => 'localhost:3000' }
    
    # Setup the I18n to allow for nested config files
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]      
APPCONFIG
        
        application app_config
        rake "db:migrate"       
      end
      
      def setup_initial_public
        template "public/stylesheets/public.css", "public/stylesheets/public.css"
        template "public/stylesheets/application.css", "public/stylesheets/application.css"
      end
      
      def overwrite_devise_settings
        gsub_file "config/initializers/devise.rb", "# config.scoped_views = false", "config.scoped_views = true"
        gsub_file "config/initializers/devise.rb", "# config.default_scope = :user", "config.default_scope = :#{@resource.singularize}"
        run "cp -R #{self.class.source_root}/devise/views #{Rails.root}/app/views/devise"
      end 

      
    end
  end
end