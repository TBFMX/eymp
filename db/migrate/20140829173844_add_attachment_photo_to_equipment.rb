class AddAttachmentPhotoToEquipment < ActiveRecord::Migration
  def self.up
    change_table :equipment do |t|
      	t.attachment :photo      
	end
  end

  def self.down
    remove_attachment :equipment, :photo
  end
end

