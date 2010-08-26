require 'generators/bootstrap'

module Bootstrap
  module Generators
    class SetupGenerator < Base
      desc "Description:\n  Sets up the initial application with devise as the underlying authentication system."
      class_option :email,    :type => :string, :default => "admin@site.com", :desc => "The initial admin account email"
      class_option :password, :type => :string, :default => "password", :desc => "The initial admin account password"      
                                 
      def install
        @resource = name.tableize
        install_other_packages
        setup_initial_configuration
        setup_initial_tests
        setup_initial_application
        overwrite_devise_settings
                                           
        # TODO: update other devise templates to use Formtastic
        # TODO: setup i18n file for Formtastic                 
        # TODO: perhaps break this up into separate methods
        
        rake "test"
      end
      
      def self.banner
        "rails generate bootstrap:#{generator_name} <account_class_name> [options]"
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
        remove_file "config/routes.rb"
        template "config/routes.rb", "config/routes.rb"        
        remove_file "#{Rails.root}/config/locales/en.yml"
        
        # TODO: need to use template so we can substitute resource name
        #remove_file "#{Rails.root}/config/locales"
        %w( views defaults ).each do |dir|
          run "cp -R #{self.class.source_root}/config/locales/#{dir} #{Rails.root}/config/locales/#{dir}"
        end 
        run "mkdir #{Rails.root}/config/locales/models"
        #run "mkdir #{Rails.root}/config/locales/#{@resource.singularize}"
        template "config/locales/models/resource/en.yml", "config/locales/models/#{@resource.singularize}/en.yml"
        run "mv #{Rails.root}/config/locales/devise.en.yml #{Rails.root}/config/locales/defaults/devise.en.yml"
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
        remove_file "#{Rails.root}/app/helpers/application_helper.rb"
        template "app/helpers/application_helper.rb", "app/helpers/application_helper.rb"
                                                                                        
        run "mkdir #{Rails.root}/app/mailers"
        
        template "app/controllers/resources_controller.rb", "app/controllers/#{@resource}_controller.rb"
        template "app/views/resources/show.html.haml", "app/views/#{@resource}/show.html.haml"
        template "app/models/resource_observer.rb", "app/models/#{@resource.singularize}_observer.rb"
        template "app/helpers/resources_helper.rb", "app/helpers/#{@resource}_helper.rb"      
        template "app/mailers/resource_mailer.rb", "app/mailers/#{@resource.singularize}_mailer.rb"
        template "app/views/resource_mailer/welcome.html.haml", "app/views/#{@resource.singularize}_mailer/welcome.html.haml"

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
      
      def overwrite_devise_settings
        gsub_file "config/initializers/devise.rb", "# config.scoped_views = false", "config.scoped_views = true"
        gsub_file "config/initializers/devise.rb", "# config.default_scope = :user", "config.default_scope = :#{@resource.singularize}"
        run "cp -R #{self.class.source_root}/devise/views #{Rails.root}/app/views/devise"
      end 

      
    end
  end
end