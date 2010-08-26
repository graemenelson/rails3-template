<% singular = @resource.singularize -%>
class <%= singular.camelize %>Mailer < ActionMailer::Base
  default :from => "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.<%= singular %>_mailer.welcome.subject
  #
  def welcome(<%= singular %>)
    @email           = <%= singular %>.email       
    @site_name       = t('application.name')
    @site_salutation = t('application.salutation')
    mail :to => <%= singular %>.email
  end
end