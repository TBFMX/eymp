class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.integer :gallery_id
      t.string :video_url
      t.string :title

      t.timestamps
    end
  end
end
