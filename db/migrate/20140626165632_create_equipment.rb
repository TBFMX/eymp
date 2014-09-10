class CreateEquipment < ActiveRecord::Migration
  def change
    create_table :equipment do |t|
      t.string :name
      t.integer :year
      t.string :color
      t.integer :brand_id
      t.integer :package_id
      t.text :description
      t.integer :publication_type
      t.integer :category_id
      t.integer :subcategory_id
      t.string  :etiquetas 
      t.decimal :precio
      t.integer :image_id
      t.integer :user_id
      t.string :modelo
      t.string :currency_id
      t.string :country_id
      t.string :state_id
      t.string :ciudad
      t.integer :rank
      t.integer :priority
      t.string :pagado
      t.integer :status
      t.timestamps
    end
  end
end

    
