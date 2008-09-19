class CreateTypusUsers < ActiveRecord::Migration

  def self.up
    create_table :typus_users do |t|
      t.string :email, :salt, :crypted_password
      t.string :first_name, :last_name
      t.boolean :status, :default => false
      t.string :roles
      t.timestamps
    end
  end

  def self.down
    drop_table :typus_users
  end

end