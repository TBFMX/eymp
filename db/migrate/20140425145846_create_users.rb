class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :password_digest
      t.string :name
      t.string :lastname
      t.string :email
      t.date :login_date
      t.date :password_date
      t.integer :rol_id
      t.string  :password_reset_token
      t.integer :package_id
      t.date  :password_reset_sent_at
      t.string :uid
      t.string :provider
      t.string :oauth_token
      t.date :oauth_expires_at
      t.integer :active
      t.timestamps
    end
  end
end
