class Equipment < ActiveRecord::Base
	extend FriendlyId
	before_save :default_values
  	friendly_id :name, :use => :slugged
	#######################################
	has_many :galleries, dependent: :destroy
	has_many :images
	has_many :ind_equipments
	belongs_to :currency 
	belongs_to :country
	belongs_to :state
	belongs_to :brand
	belongs_to :package
	belongs_to :category

	######################## Prueba de Paperclip ###################################
	#has_attached_file :photo, :styles => { :small => "690x320#" , :large => "700x700>"},
	#  :url => "/data/:attachment/:id/:style/:basename.:extension",
  	#  :path => ":rails_root/public/data/:attachment/:id/:style/:basename.:extension"

  	#attr_accessor :crop_x, :crop_y, :crop_w, :crop_h  

	#validates_attachment_size :photo, :less_than => 5.megabytes
	#validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']			
	################################################################################	

	#validates :equipment_id, presence: true, uniqueness: true
	validates :name, presence: true, uniqueness: true
	#validates_format_of :name, :with => /^([^\/]*)$/i
	validates :currency_id, presence: true
	validates :modelo ,presence: true
	validates :state_id, presence: true
	validates :brand_id, presence: true
	validates :country_id, presence: true
	validates :publication_type, presence: true
	validates :category_id, presence: true
	validates :ciudad, presence: true
	validates :package_id, presence: true


	has_many :comments
	#has_many :coments, dependent: :destroy
	


	validates :precio, numericality: {greater_than_or_equal_to: 0.01}
	#validates :currency_id, :description, presence: true


  	def default_values
   	 self.status ||= '0'
  	end


	def should_generate_new_friendly_id?
    	new_record?
  	end

  	def self.s_charge(zona)
  		aux =Equipment.where("package_id = ? and status <> 0", zona).count()
  		if aux > 4
	  		count = 0
	  		#content_aux = ""
	  		array_aux = Array.new
	  		equip = Equipment.select("id").where("package_id = ? and status <> 0", zona)
  			array_conteiner = Array.new

	  		 equip.each do |e|
	  		 	array_conteiner.push(e.id)
	  		 end	

	  		if aux >= 20
	  			
		  		while count < 20 do

		  			#esta = false
		  			i_aux = array_conteiner.sample.to_i
		  			
	  				array_aux.push(i_aux)
	  				array_conteiner.delete(i_aux)
	  				count += 1	
		  		end
		  	elsif aux < 20

		  		while count < aux.to_i do

		  			i_aux = array_conteiner.sample.to_i
	  				array_aux.push(i_aux)
	  				array_conteiner.delete(i_aux)
	  				count += 1
		  		end		
	  		end
	  		where(id: array_aux)
	  	else
	  		where("package_id = ? and status <> 0", zona)
	  	end	  	
  	end

  	def self.s_principal_charge
  		aux =Equipment.where("priority = 100 ").where_activo.count()
  		if aux > 8
	  		count = 0
	  		#content_aux = ""
	  		array_aux = Array.new
	  		equip = Equipment.select("id").where("priority = 100").where_activo
  			array_conteiner = Array.new

	  		 equip.each do |e|
	  		 	array_conteiner.push(e.id)
	  		 end	

	  		while count < 8 do
	  			#esta = false
	  			i_aux = array_conteiner.sample.to_i

  				array_aux.push(i_aux)
  				array_conteiner.delete(i_aux)
  				count += 1	
	  		end
		  	
	  		where(id: array_aux)
	  	else
	  		where("priority = 100")
	  	end	  	
  	end

  	def self.find_custom(equip)
  		aux = Equipment.find(equip)
  		if aux.status == 2
  			find(equip)
  		else
  			nil
  		end	
  	end

  	def self.find_by_custom(arg)
  		aux = Equipment.find_by(arg)
  		if aux.status == 2
  			find_by(arg)
  		else
  			nil
  		end	
  	end

  	##############################
	#status 0 = inactivo
	#status 1 = pendiente de pagar
	#status 2 = pagado/activo
	#status 3 = desactivado
	##############################
  	def self.where_activo
  		where("status = 2")
  		
  	end
  	def self.where_inactivo
  		where("status = 0")
  		
  	end
  	def self.where_pendiente
  		where("status = 1")
  		
  	end
  	def self.where_desactivado
  		where("status = 3")
  		
  	end	

  	def self.where_venta
  		where("publication_type = 1")
  	end

  	def self.where_renta
  		where("publication_type = 2")
  	end

	def self.search(search)
	  if search
	  	aux = '%' + search + '%'
	  	#aux = search 
	    where('name LIKE ? or description LIKE ? or etiquetas LIKE ?', aux,aux,aux)
	    #.order('package DESC,rank ASC, priority ASC')
	  else
	    all
	  end
	end


		
	def self.query_rep_stat(equipment)
	    @aux= " 1 = 1 "
	    @aux2= Array.new
	    @cont=1
	    if equipment
		    if !equipment[:name].blank?
		    	@aux= @aux + 'and name = ? '
		    	@aux2[@cont]=  equipment[:name]
		    	@cont=@cont+1
		    end
		    if !equipment[:status].blank?
		    	@aux= @aux + 'and status = ? '
		    	@aux2[@cont]=  equipment[:status]
		    	@cont=@cont+1
		    end
		    

		    if !equipment[:desde].blank? || !equipment[:hasta].blank?
		    	
		    	if !equipment[:desde].blank? && !equipment[:hasta].blank?
		    		if equipment[:desde] != equipment[:hasta]
			    		@aux= @aux + 'and updated_at between  ? and ? '
			    		@aux2[@cont]= equipment[:desde]
			    		@aux2[@cont+1]= equipment[:hasta]
			    	else
			    		@aux= @aux + 'and updated_at = ? '
			    		@aux2[@cont]= equipment[:desde]
			    		
			    	end	
		    	elsif equipment[:desde] && equipment[:hasta].blank?
		    		@aux= @aux + 'and updated_at <= ? '
		    		@aux2[@cont]= equipment[:desde]
		    	elsif equipment[:desde].blank? && equipment[:hasta]
		    		@aux= @aux + 'and updated_at >= ? '
		    		@aux2[@cont]= equipment[:hasta]			
		    	end
		    end
		end
	    if @aux
	    #puts @cont	
		      @aux2[0]=@aux
	      where @aux2 
	    else
	      scoped
	    end

	end

	def self.query(equipment)
	    @aux= " 1 = 1 "
	    @aux2= Array.new
	    @cont=1
	    if equipment
		    if !equipment[:year].blank?
		    	@aux= @aux + 'and year = ? '
		    	@aux2[@cont]=  equipment[:year]
		    	@cont=@cont+1
		    end
		    if !equipment[:color].blank?
		    	@aux= @aux + 'and color = ? '
		    	@aux2[@cont]=  equipment[:color]
		    	@cont=@cont+1
		    end
		    if !equipment[:brand_id].blank?
		    	@aux= @aux + 'and brand_id = ? '
		    	@aux2[@cont]= equipment[:brand_id]
		    	@cont=@cont+1
		    end

		    if !equipment[:package_id].blank?
		    	@aux= @aux + 'and package_id = ? '
		    	@aux2[@cont]=  equipment[:package_id]
		    	@cont=@cont+1
		    end
		    if !equipment[:modelo].blank?
		    	@aux= @aux + 'and modelo = ? '
		    	@aux2[@cont]=  equipment[:modelo]
		    	@cont=@cont+1
		    end
		    if !equipment[:currency_id].blank?
		    	@aux= @aux + 'and currency_id = ? '
		    	@aux2[@cont]= equipment[:currency_id]
		    	@cont=@cont+1
		    end

		    if !equipment[:country_id].blank?
		    	@aux= @aux + 'and country_id = ? '
		    	@aux2[@cont]=  equipment[:country_id]
		    	@cont=@cont+1
		    end
		    if !equipment[:state_id].blank?
		    	@aux= @aux + 'and state_id = ? '
		    	@aux2[@cont]=  equipment[:state_id]
		    	@cont=@cont+1
		    end
		    if !equipment[:ciudad].blank?
		    	@aux= @aux + 'and ciudad = ? '
		    	@aux2[@cont]= equipment[:ciudad]
		    	@cont=@cont+1
		    end
		    if !equipment[:category_id].blank?
		    	@aux= @aux + 'and category_id = ? '
		    	@aux2[@cont]= equipment[:category_id]
		    	@cont=@cont+1
		    end
		    if !equipment[:subcategory_id].blank?
		    	@aux= @aux + 'and subcategory_id = ? '
		    	@aux2[@cont]= equipment[:subcategory_id]
		    	@cont=@cont+1
		    end

		    if !equipment[:preciod].blank? || !equipment[:precioh].blank?
		    	
		    	if !equipment[:preciod].blank? && !equipment[:precioh].blank?
		    		if equipment[:preciod] != equipment[:precioh]
			    		@aux= @aux + 'and precio between  ? and ? '
			    		@aux2[@cont]= equipment[:preciod]
			    		@aux2[@cont+1]= equipment[:precioh]
			    	else
			    		@aux= @aux + 'and precio = ? '
			    		@aux2[@cont]= equipment[:preciod]
			    		
			    	end	
		    	elsif equipment[:preciod] && equipment[:precioh].blank?
		    		@aux= @aux + 'and precio <= ? '
		    		@aux2[@cont]= equipment[:preciod]
		    	elsif equipment[:preciod].blank? && equipment[:precioh]
		    		@aux= @aux + 'and precio >= ? '
		    		@aux2[@cont]= equipment[:precioh]			
		    	end
		    end
		end
	    if @aux
	    #puts @cont	
		      @aux2[0]=@aux
	      where @aux2 
	    else
	      scoped
	    end

	end

	def self.where_category(category)
		where("category_id = ?", category)
	end

end
