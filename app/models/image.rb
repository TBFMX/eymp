class Image < ActiveRecord::Base
	#######################################
	#extend FriendlyId
  	#friendly_id :title, :use => :slugged
	#######################################
	#belongs_to :gallery

	#validates :gallery_id, presence: true
	#validates_format_of :name, :with => /^([^\/]*)$/i


	######################## Prueba de Paperclip ###################################
	has_attached_file :photo, :styles => { :small => "690x320#" ,:zona => "280x190", :large => "700x700>"},
	  :url => "/data/:attachment/:id/:style/:basename.:extension",
  	  :path => ":rails_root/public/data/:attachment/:id/:style/:basename.:extension"

  	attr_accessor :crop_x, :crop_y, :crop_w, :crop_h  

	validates_attachment_size :photo, :less_than => 5.megabytes
	validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']			
	################################################################################

	def existence(url)
      	uri = URI(url)
		request = Net::HTTP.new uri.host
		response= request.request_head uri.path
		return response.code.to_i == 200
    end
end
