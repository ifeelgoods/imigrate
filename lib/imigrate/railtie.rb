require 'active_record'
require 'active_record/migration'

module Imigrate
  class Railtie < Rails::Railtie
    rake_tasks do
      load File.join(File.dirname(__FILE__), '..', 'tasks/databases.rake')
    end
  end
end