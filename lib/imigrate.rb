require_relative 'imigrate/railtie'
require_relative 'generators/imigrate'

module Imigrate
  mattr_reader :env_prefix
  mattr_accessor :activated

  def self.env_prefix=(number)
    return if number.blank?
    raise 'env_prefix must be a number' unless number.is_a?(Integer)
    @@env_prefix = number
  end
  SCHEMA_MIGRATIONS_TABLE_NAME = 'data_migrations'
  MIGRATION_PATH = ['db/data']
end
