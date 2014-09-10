class Brand < ActiveRecord::Base
	extend FriendlyId
  	friendly_id :name, :use => :slugged
  	#validates_format_of :name, :with => /^([^\/]*)$/i
	validates :name, presence: true, uniqueness: true
	has_many :equipments
end
