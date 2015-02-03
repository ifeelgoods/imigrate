class PopulateUser2 < ActiveRecord::Migration
  def self.up
    User.create!(first_name: 'toto2', last_name: 'tata2')
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
