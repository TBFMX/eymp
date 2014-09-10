class Gallery < ActiveRecord::Base
	extend FriendlyId
	friendly_id :title, :use => :slugged
	##########################################
	belongs_to :equipment
	has_many :images, dependent: :destroy
	has_many :videos, dependent: :destroy

	validates :equipment_id, presence: true
	validates :title, presence: true

end
