class PopulateUser < ActiveRecord::Migration
  def self.up
   User.create!(first_name: 'toto', last_name: 'tata')
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
