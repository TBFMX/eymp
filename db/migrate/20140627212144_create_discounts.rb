class CreateDiscounts < ActiveRecord::Migration
  def change
    create_table :discounts do |t|
      t.string :titulo
      t.decimal :precio
      t.date :vencimiento
      t.decimal :precio_anterior
      t.belongs_to :equipment, index: true

      t.timestamps
    end
  end
end
