module ApplicationHelper

  def page_header( tag = "h2", options = {} )
    content_tag(tag, I18n.t("#{controller_name}.#{action_name}.header"), {} )
  end
  
end