require_relative 'imigrate/railtie'
require_relative 'generators/imigrate'

module Imigrate
  mattr_accessor :env_prefix
  mattr_accessor :activated
  SCHEMA_MIGRATIONS_TABLE_NAME = 'data_migrations'
  MIGRATION_PATH = 'db/data'
end
