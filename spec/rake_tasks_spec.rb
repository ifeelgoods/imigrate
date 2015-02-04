require 'spec_helper'
require 'fileutils'

describe 'rake tasks' do

  ### Helpers ###
  def rails_app_root
    "#{MIGRATOR_ROOT}/spec/dummy"
  end
  def debug(mes)
    if ENV['DEBUG'] == 'true'
      puts mes
    end
  end

  def insert_migration_test
    FileUtils.copy_file("#{rails_app_root}/db/migrate_test/20150202174939_modify_user.rb", "#{rails_app_root}/db/migrate/20150202174939_modify_user.rb")
  end

  def reset_migration_and_db
    FileUtils.remove_file("#{rails_app_root}/db/migrate/20150202174939_modify_user.rb")
    exec_cmd('rake db:drop')
    exec_cmd('git checkout db/schema.rb')
    exec_cmd('rake db:setup')
  end

  def get_data_versions
    ActiveRecord::Base.establish_connection
    res = ActiveRecord::Base.connection.execute('SELECT * from data_migrations').to_a.map{|r| r['version']}
    debug "Result get_data_versions: #{res}"
    res
  end

  def get_versions
    ActiveRecord::Base.establish_connection
    res = ActiveRecord::Base.connection.execute('SELECT * from schema_migrations').to_a.map{|r| r['version']}
    debug "Result get_versions: #{res}"
    res
  end

  def exec_cmd(cmd)
    cmd_final = "cd #{rails_app_root} && RAILS_ENV=test #{cmd}"

    debug "Executing: #{cmd_final}"
    res = `#{cmd_final}`
    debug "Result: #{res}"
    res
  end

  def rake(task)
    exec_cmd("rake #{task}")
  end
  #### End Helpers ####

  describe 'db:data:migrate' do
    before do
      DatabaseCleaner.clean
    end

    it "add an user" do
      expect{rake('db:data:migrate')}.to change{User.count}.by (2)
    end

    it "add version to data_migration" do
      rake('db:data:migrate')
      expect(get_data_versions.any?).to eq(true)
    end

    it "does not change schema migration" do
      expect{rake('db:data:migrate')}.to_not change{get_versions}
    end
  end

  describe 'db:migrate' do
    before do
      ActiveRecord::Base.establish_connection
      DatabaseCleaner.clean
      insert_migration_test
    end
    after do
      reset_migration_and_db
    end

    it 'does not add an user' do
      expect{rake('db:migrate')}.to_not change{User.count}
    end

    it "does not add version to data_migration" do
      rake('db:migrate')
      expect(get_data_versions.any?).to eq(false)
    end

    it "does add version to schema" do
      rake('db:migrate')
      expect(get_versions).to include('20150202174939')
    end
  end

  describe 'db:migrate:all' do
    before do
      ActiveRecord::Base.establish_connection
      DatabaseCleaner.clean
      insert_migration_test
    end
    after do
      reset_migration_and_db
    end

    it 'does add an user and change the schema' do
      rake('db:migrate:all')
      expect(User.count).to eq(2)
      expect(get_versions).to include('20150202174939')
      expect(get_data_versions).to include('20150202183455')
    end
  end

  context 'setting an env_prefix' do
    before do
      ActiveRecord::Base.establish_connection
      DatabaseCleaner.clean
      insert_migration_test
    end
    after do
      reset_migration_and_db
    end

    it 'does add an user and change the schema' do
      rake('DATA_MIGRATOR_ENV_PREFIX=10 db:migrate:all')
      expect(User.count).to eq(2)
      expect(get_versions).to include('20150202174939')
      expect(get_data_versions).to include('1020150202183455')
    end

    describe 'when changing env_prefix' do
      it 'contains version for both env' do
        rake('DATA_MIGRATOR_ENV_PREFIX=10 db:data:migrate')
        expect(get_data_versions).to include('1020150202183455')
        expect(get_data_versions).to_not include('2020150202183455')
        expect(User.count).to eq(2)
        rake('DATA_MIGRATOR_ENV_PREFIX=20 db:data:migrate')
        expect(get_data_versions).to include('1020150202183455')
        expect(get_data_versions).to include('2020150202183455')
        expect(User.count).to eq(4)
        rake('DATA_MIGRATOR_ENV_PREFIX=20 db:data:migrate')
        expect(get_data_versions).to include('1020150202183455')
        expect(get_data_versions).to include('2020150202183455')
        expect(User.count).to eq(4)
      end
    end
  end
end