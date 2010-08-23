class <%= @resource.camelize %>Controller < ApplicationController
  
  before_filter :authenticate_<%= @resource.singularize %>!
  
  def show
  end
  
end
