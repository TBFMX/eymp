class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.integer :gallery_id
      t.string :image_url
      t.string :title

      t.timestamps
    end
  end
end
