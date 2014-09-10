class CreateControlPanels < ActiveRecord::Migration
  def change
    create_table :control_panels do |t|
      t.string :admin
      t.string :system
      t.integer :newadv

      t.timestamps
    end
  end
end
