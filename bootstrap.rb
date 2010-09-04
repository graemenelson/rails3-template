require 'rails/generators/named_base'

module Bootstrap
  module Generators
    class Base < Rails::Generators::NamedBase #:nodoc:
      def self.source_root
        @_bootstrap_source_root ||= File.expand_path(File.join(File.dirname(__FILE__), 'bootstrap', generator_name, 'templates'))
      end
    end
  end
end