class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :username
      t.string :password

      t.timestamps
    end
    User.new(:username => 'admin', :password => 'admin').save!
  end

  def self.down
    drop_table :users
  end
end
