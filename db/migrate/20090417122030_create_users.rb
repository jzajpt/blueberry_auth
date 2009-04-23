class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users, :force => true do |t|
      t.string :email, :limit => 250
      t.string :name, :limit => 250
      t.string :password_hash, :limit => 250
      t.string :password_salt, :limit => 250
      t.datetime :last_signin_at
      t.string :token
      t.datetime :token_expires_at
      t.timestamps
    end

    add_index :users, :email, :unique => true
    add_index :users, [:id, :token]
  end

  def self.down
    drop_table :users
  end
end
