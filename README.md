Rails 3 Application Template
============================

A rails 3 application template to set up authentication, testing, and template frameworks.  The authentication system uses [devise](http://github.com/plataformatec/devise) for the basic authentication support. The testing framework used is [shoulda](http://github.com/thoughtbot/shoulda) with [factory girl](http://github.com/thoughtbot/factory_girl_rails) and [mocha](http://github.com/floehopper/mocha) support. [HAML](http://haml-lang.com/) is used as the templating engine, with initial [SASS](http://sass-lang.com/) support for the css. [Formtastic](http://github.com/justinfrench/formtastic) is included for pretty forms support.    

[JQuery](http://jquery.com/) is used as the default javascript library.

The template also include [gemset](http://rvm.beginrescueend.com/gemsets/) support for [rvm](http://rvm.beginrescueend.com/).

Credit: This template is based off of [Les Hill Template](http://github.com/leshill/rails3-app/raw/master/app.rb).
                                                                                                         
Using The Template
-----------------------------

Assuming you have Rails 3 RC installed, you can run the following command.

    rails new appname -m http://github.com/graemenelson/rails3-template/raw/master/template.rb
                  
And a new Rails 3 application will be built and placed in the directory given by *appname*. Follow the given steps, and you are ready to go.
                                     
Next Steps
------------------------------

After the initial template is created, you can run the following command from within your application directory:

    rails g rails g bootstrap:setup ModelName
    
Where *ModelName* is the name you want to give to the user model in your system.  For example, if you want to use *Account* model then use the following command:

    rails g bootstrap:setup Account
    
If you want to use *AdminUser*, then you can use:

    rails g bootstrap:setup AdminUser
    

                                                                                  

