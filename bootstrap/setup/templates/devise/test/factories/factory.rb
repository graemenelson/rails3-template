# Read about factories at http://github.com/thoughtbot/factory_girl
Factory.define :<%= @resource.singularize %> do |f|
  f.email "someuser@site.com"
  f.password "password"
  f.password_confirmation "password"
end