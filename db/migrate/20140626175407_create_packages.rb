class CreatePackages < ActiveRecord::Migration
  def change
    create_table :packages do |t|
      t.string :name
      t.decimal :price
      t.string :description
      t.text :botton_one
      t.text :botton_suscription
      t.timestamps
    end
  end
end
