class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :name
      t.string :email
      t.string :contact
      t.string :mensaje
      t.timestamps
    end
  end
end
