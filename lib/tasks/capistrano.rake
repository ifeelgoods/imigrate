namespace :deploy do
  namespace :migrate do
    desc 'Runs rake db:data:migrate if migrations are set'
    task :data => [:set_rails_env] do
      on primary fetch(:migration_role) do
        within release_path do
          with rails_env: fetch(:rails_env) do
            migrate_env = fetch(:migrate_env, "")
            execute :rake, "db:data:migrate #{migrate_env} "
          end
        end
      end
    end
  end

  after 'deploy:migrate', 'deploy:migrate:data'
end
