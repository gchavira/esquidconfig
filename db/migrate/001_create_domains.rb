class CreateDomains < ActiveRecord::Migration
  def self.up
    create_table :domains do |t|
      t.string :domain
      t.string :description
      t.boolean :active

      t.timestamps
    end
  end

  def self.down
    drop_table :domains
  end
end
