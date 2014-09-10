class DataFile < ActiveRecord::Base
	#sobre-escribimos el save para guardar el file
	def self.save(upload , id , name)
		# puts "-----------------direccion actual-1--------------"
		# puts Dir.pwd
		# puts "------------------------------------------------"
		carpeta = id.to_s + "_" + name.to_s

		#variables de diferenciación
		@yolo = rand(5..120)
		@yolo2 = rand(5..120)
		############################
		upload.original_filename = @yolo2.to_s + "_" + @yolo.to_s + "_" +upload.original_filename 
	    name =  upload.original_filename
	    
		
	    @path2 = ""

    	directory = "public/data"
    	Dir.chdir(directory) do
	    	directory = carpeta.to_s
	    	path = File.join(directory, name)
			# puts "-----------------direccion actual-2--------------"
			# puts Dir.pwd
			# puts "------------------------------------------------"
		   

			##############
			Dir.mkdir(carpeta,0775) unless File.exists?(carpeta)
			##############

		    dir ="/data/" + carpeta.to_s
		    @path2 = File.join(dir, name)
		    # write the file
		    File.open(path, "wb") { |f| f.write(upload.read) }

	    end

	    return @path2
	end

	def self.destroy(url)
		url_dir = "public" + url.to_s
		if File.exist?(url_dir)
			if File.delete(url_dir) 
				puts '-------Destrui la pic ' + url_dir + 'y ya no debe estar NNNNNNNNNNNNNNNNOOOOOOOOOOOOOOOOOOOO---------------'
				return true
			else
				return false	
			end	
		else
		# puts "no existe " + url_dir.to_s
		# puts url.to_s
		# puts Dir.pwd	
		end	
		
		#return true
	end	


		
		
end
