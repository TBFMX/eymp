class CreateIndEquipments < ActiveRecord::Migration
  def change
    create_table :ind_equipments do |t|
      t.integer :industry_id
      t.integer :equipment_id

      t.timestamps
    end
  end
end
