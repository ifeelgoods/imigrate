require 'rails/generators'
require 'rails/generators/named_base'
require 'rails/generators/migration'

module Imigrate
  module Generators
    class DataMigrationGenerator < Rails::Generators::NamedBase #:nodoc:
      namespace "data_migration"
      include Rails::Generators::Migration

      def self.source_root
        @_data_migrator_source_root ||= File.expand_path(File.join(File.dirname(__FILE__), 'templates'))
      end

      def create_data_migration
        migration_template "data_migration.rb", "db/data/#{file_name}.rb"
      end

      protected

      def self.next_migration_number(dirname)
        if ActiveRecord::Base.timestamped_migrations
          Time.new.utc.strftime("%Y%m%d%H%M%S")
        else
          "%.3d" % (current_migration_number(dirname) + 1)
        end
      end
    end
  end
end
