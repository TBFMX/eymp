class Comment < ActiveRecord::Base
	####################################
	#extend FriendlyId
  	#friendly_id :name, :use => :slugged
  	####################################
	belongs_to :equipment
	validates :equipment_id, presence: true
	
	validates :user_id, presence: true
	validates :comment, presence: true
	belongs_to :user
end
