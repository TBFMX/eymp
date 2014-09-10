class Category < ActiveRecord::Base
	######################################
	extend FriendlyId
	friendly_id :title, :use => :slugged
	######################################
	validates :title, presence: true, uniqueness: true
	#validates_format_of :title, :with => /^([^\/]*)$/i

	has_many :subcategories
end
