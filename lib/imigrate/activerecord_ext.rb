#require it, only when needed!

if Imigrate.activated == true
  class ActiveRecord::MigrationProxy
    def initialize(name, version, filename, scope)
      if Imigrate.env_prefix.present?
        version = "#{Imigrate.env_prefix}_#{version}"
      end

      super(name, version, filename, scope)
    end
  end
  class ActiveRecord::Migrator
    private
    def ran?(migration)
      migrated.include?(migration.version)
    end
  end
end
