namespace :db do
  namespace :migrate do
    desc 'Migrate schema and data migrations (options: VERSION=x, VERBOSE=false)'
    task :all do
      system('rake db:migrate')
      system('rake db:data:migrate')
    end
  end

  namespace :data do
    task :load_config do
      Imigrate.activated = true
      require_relative '../imigrate/activerecord_ext'
      ActiveRecord::Tasks::DatabaseTasks.migrations_paths = Imigrate::MIGRATION_PATH
      ActiveRecord::Base.schema_migrations_table_name = Imigrate::SCHEMA_MIGRATIONS_TABLE_NAME
    end

    task :insert_versions => [:environment, :load_config] do
      versions = []
      ActiveRecord::Tasks::DatabaseTasks.migrations_paths.each do |path|
        Dir.foreach(path) do |file|
          # match "20091231235959_some_name.rb" and "001_some_name.rb" pattern
          if match_data = /^(\d{3,})_(.+)\.rb$/.match(file)
            versions << ActiveRecord::SchemaMigration.normalize_migration_number(match_data[1])
          end
        end
      end
      versions.each do |version|
        ActiveRecord::SchemaMigration.create!(:version => version.to_s)
      end
    end

    desc 'Migrate data migrations (options: VERSION=x, VERBOSE=false)'
    task :migrate => [:environment, :load_config] do
      Rake::Task["db:migrate"].invoke
    end

    namespace :migrate do
      desc 'Rollbacks the database one migration and re migrate up (options: STEP=x, VERSION=x).'
      task :redo => [:environment, :load_config] do
        Rake::Task["db:migrate:redo"].invoke
      end

      desc 'Runs the "up" for a given migration VERSION.'
      task :up => [:environment, :load_config] do
        Rake::Task["db:migrate:up"].invoke
      end

      desc 'Runs the "down" for a given migration VERSION.'
      task :down => [:environment, :load_config] do
        Rake::Task["db:migrate:down"].invoke
      end

      desc "Retrieves the current schema version number for data migrations"
      task :status => [:environment, :load_config] do
        Rake::Task["db:migrate:status"].invoke
      end
    end

    desc "Display status of data migrations"
    task :version => [:environment, :load_config] do
      Rake::Task["db:version"].invoke
    end

    desc 'Rolls the schema back to the previous version (specify steps w/ STEP=n).'
    task :rollback => [:environment, :load_config] do
      Rake::Task["db:rollback"].invoke
    end

    desc 'Pushes the schema to the next version (specify steps w/ STEP=n).'
    task :forward => [:environment, :load_config] do
      Rake::Task["db:forward"].invoke
    end
  end
end