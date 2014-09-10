class CreateSubcategories < ActiveRecord::Migration
  def change
    create_table :subcategories do |t|
      t.string :category_id
      t.string :title
      t.integer :subcategory_id
      t.timestamps
    end
  end
end
