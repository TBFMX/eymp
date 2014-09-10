#!/bin/env ruby
# encoding: utf-8
class EquipmentRentController < ApplicationController
before_action :set_equipment, only: [:show, :edit, :update, :destroy]
  helper_method :sort_column, :sort_direction
  skip_before_action :authorize, only: [:show,:grid,:search,:industry]

  # GET /equipment
  # GET /equipment.json
  def index
    @equipment = Equipment.where_activo.where_renta
  end

  # GET /equipment/1
  # GET /equipment/1.json
	def show
	    @categoria = Category.find(@equipment.category_id)
	    if @categoria.father_id != 0
	      categoria2 = Category.find(@categoria.father_id)
	      add_breadcrumb categoria2.slug.to_s, Filtro_path('categoria' => categoria2.title, 'tipo' => 1)
	    end 
	    add_breadcrumb @categoria.slug.to_s, Filtro_path('categoria' => @categoria.title, 'tipo' => 1)
	    add_breadcrumb @equipment.slug.to_s, equipment_path(@equipment)   
	    if @equipment.image_id
	      @image = Image.find(@equipment.image_id)
	    else
	      @image = Image.find_by(image_url: '/data/dummy.png')  
	    end  
	     @gallery = Gallery.where('equipment_id = ?', @equipment.id)
	     @user = User.find(@equipment.user_id)
	     @currency = Currency.find(@equipment.currency_id)
	     @comments = Comment.where('equipment_id = ?', @equipment.id)
	     
	     # puts "-------------------Comments---------------------------"
	     # puts @comments.inspect
	     # puts "----------------------------------------------"    

	     @comment = Comment.new('user_id' => session[:user_id],"equipment_id" => @equipment.id)
	end

  # GET /equipment/new
  def new
    add_breadcrumb 'newequipment', new_equipment_path
    @equipment = Equipment.new('user_id' => session[:user_id])
  end

  # GET /equipment/1/edit
  def edit
    if propiedad(@equipment.user_id)
      add_breadcrumb @equipment.name.to_s, edit_equipment_path(@equipment)
    else
      redirect_to equipment_path(@equipment), notice: 'no esta autorizado a hacer cambios en ese equipo'
    end  
  end

  # POST /equipment
  # POST /equipment.json
	def create
	    #@equipment = Equipment.new(equipment_params)
	    session[:url_to_return] = ""
	    @user = User.find(session[:user_id])
	    @equipment = Equipment.new(equipment_params)
	    # puts "-------------------Equipo---------------------------"
	    #   puts @equipment.inspect
	    # puts "----------------------------------------------"
	    #   @pic = params[:equipment][:image_id]
	    # puts "-------------------Pic---------------------------"
	    #   puts @pic.inspect
	    # puts "----------------------------------------------"
	    # puts "-------------------Pics---------------------------"
	    #   puts @pics.inspect
	    # puts "--------------------------------------------------" 
	    respond_to do |format|
	      if secure_save(@equipment)
	        format.html { 
	          #saco la id del proyecto
	          @equipments = Equipment.find(@equipment)
	          # puts "-------------------Equipo---------------------------"
	          # puts @equipments.inspect
	          # puts "------------------------------------------------------"
	          ########################
	          unless @pic.nil?
	            @pics = DataFile.save(@pic,@equipments.id.to_s, @equipments.slug.to_s)
	          else
	            @pics = "/data/dummy.png"  
	          end
	          ########################
	          
	          
	          #creo la galleria
	            @gallery=Gallery.new("equipment_id"=>@equipments.id, "title" =>"principal")
	            # puts "--------------------Galleria--------------------------"
	            # puts @gallery.inspect
	            # puts "------------------------------------------------------"
	            respond_to do |format|
	              if secure_save(@gallery)
	                format.html {
	                  @galleries = Gallery.find(@gallery)
	                    unless @pic.nil?
	                    #puts "pase la validacion de pic"
	                      @image = Image.new("gallery_id" => @galleries.id, "image_url" => @pics)
	                      #puts "--------------------Imagen--------------------------"
	                      #puts @image.inspect
	                      #puts "----------------------------------------------------"
	                      
	                      respond_to do |format|
	                        if secure_save(@image)
	                       #   puts "entre a imagen"
	                          format.html { 
	                            respond_to do |format|
	                              if @equipments.update("image_id" => @image.id)
	                                format.html { 
	                                 #me voy al show del equipo
	                                  Mailer.create_equip(@user,@equipment).deliver
	                                  redirect_to @equipment, notice: 'Equipment was successfully created.'
	                                }
	                                format.json { }
	                              else
	                                format.html { redirect_to root_path, alert: "fallo el update de proyecto" }
	                                format.json {  }
	                              end
	                            end                      
	                          }
	                          format.json { }
	                        else
	                        #  puts "entre a imagen"
	                          format.html { redirect_to root_path, alert: "fallo el salvado de la imagen" }
	                          format.json {  }
	                        end
	                      end
	                    else
	                      redirect_to @equipment, notice: 'Equipment was successfully created.'
	                    end  
	                }
	                format.json {  }
	              else
	                format.html { redirect_to root_path, alert: "fallo el salvado de la Galeria" }
	                format.json {  }
	              end
	            end
	              
	        }
	        format.json { render :show, status: :created, location: @equipment }
	      else
	        format.html { render :new }
	        format.json { render json: @equipment.errors, status: :unprocessable_entity }
	      end
	    end
=begin
	    respond_to do |format|
	      if @equipment.save
	        format.html { redirect_to @equipment, notice: 'Equipment was successfully created.' }
	        format.json { render :show, status: :created, location: @equipment }
	      else
	        format.html { render :new }
	        format.json { render json: @equipment.errors, status: :unprocessable_entity }
	      end
	    end
=end    
	end

  # PATCH/PUT /equipment/1
  # PATCH/PUT /equipment/1.json
	def update

	    if propiedad(@equipment.user_id)
	      @pic = params[:equipment][:image_id]
	      # puts "-------------------Pic---------------------------"
	      #   puts @pic.inspect
	      # puts "----------------------------------------------"
	      # puts "-------------------Pics---------------------------"
	      #   puts @pics.inspect
	      # puts "--------------------------------------------------" 

	      respond_to do |format|
	        if @equipment.update(equipment_params)
	          format.html { 
	            unless @pic.nil?
	              @pics = DataFile.save(@pic,@equipment.id.to_s, @equipment.slug.to_s)
	            else
	              @pics = nil
	            end
	            unless @pics.nil?
	            #creo la galleria
	              @gal = Gallery.where("equipment_id = ? and title = 'principal' ", @equipment.id ).count
	              if @gal > 0 
	  #                puts "--------------------------gal count---------------------------------"
	  #               puts "-----" + @gal.to_s + "----------------------------------------------"
	  #              puts "--------------------------------------------------------------------"
	                @gallery=Gallery.where("equipment_id = ? and title = 'principal' ", @equipment.id ).first
	              else
	                @gallery=Gallery.new("equipment_id"=>@equipment.id, "title" =>"principal")
	              end    
	   #             puts "--------------------Galleria--------------------------"
	    #            puts @gallery.inspect
	     #           puts "------------------------------------------------------"
	                respond_to do |format|
	                  if secure_save(@gallery)
	                    format.html {
	                      @galleries = Gallery.find(@gallery)
	                      
	      #                  puts "pase la validacion de pic"
	                          @image = Image.new("gallery_id" => @galleries.id, "image_url" => @pics)
	                          puts "--------------------Imagen--------------------------"
	                          puts @image.inspect
	                          puts "----------------------------------------------------"
	                          
	                          respond_to do |format|
	                            if secure_save(@image)
	       #                       puts "entre a imagen"
	                              format.html { 
	                                respond_to do |format|
	                                  if @equipment.update("image_id" => @image.id)
	                                    format.html { 
	                                     #me voy al show del equipo
	                                      redirect_to dashboard_equipos_path, notice: 'Los cambios se han guardado con exito' 
	                                    }
	                                    format.json { }
	                                  else
	                                    format.html { redirect_to root_path, alert: "fallo el update de proyecto" }
	                                    format.json {  }
	                                  end
	                                end                      
	                              }
	                              format.json { }
	                            else
	        #                      puts "entre a imagen"
	                              format.html { redirect_to root_path, alert: "fallo el salvado de la imagen" }
	                              format.json {  }
	                            end
	                          end    
	                     }
	                    format.json {  }
	                  else
	                    format.html { redirect_to root_path, alert: "fallo el salvado de la Galeria" }
	                    format.json {  }
	                  end
	                end

	            else
	              redirect_to dashboard_equipos_path, notice: 'Los cambios se han guardado con exito' 
	            end
	          }
	          format.json { render :show, status: :ok, location: @equipment }
	        else
	          format.html { render :edit }
	          format.json { render json: @equipment.errors, status: :unprocessable_entity }
	        end
	      end
	    else
	      redirect_to dashboard_equipos_path, notice: 'no esta autorizado a hacer cambios en ese equipo' 
	    end  
	end

  # DELETE /equipment/1
  # DELETE /equipment/1.json
    def destroy
    	#antes hay que limpiar todo
	    @gallery = Gallery.where('equipment_id = ?', @equipment.id)
	    #puts"---------------------galerias del equipo---------------------------------"
	    #puts @gallery.inspect
	    #puts"-------------------------------------------------------------------------"
	    @gallery.each do |gallery|
	    #  puts"--------------------galeria--------------------------------------------"
	    #  puts gallery.inspect
	    #  puts"-----------------------------------------------------------------------"
	    #  @image = Image.where('gallery_id = ?', gallery.id)
	    #  puts"--------------------imagenes de la galeria-----------------------------"
	    #  puts @image.inspect
	    #  puts"-----------------------------------------------------------------------"
	      @image.each do |image|
	    #    puts"-------------------imagen--------------------------------------------"
	    #    puts image.inspect
	    #    puts"---------------------------------------------------------------------"
	        pic = image.image_url
	    #   puts"----------------------url de la imagen-------------------------------"
	    #   puts pic
	    #    puts"---------------------------------------------------------------------"
	        unless pic.equal?("/data/dummy.png")
	        
	          pics = DataFile.destroy(pic)
	     #     puts '-------Destrui la pic ' + pic + 'y ya no debe estar'
	        end
	      end
	    end  
	    #@equipment.destroy
	    respond_to do |format|
	      if @equipment.update("status" => 0)
	        format.html {    
	          @equips = Equipment.find_by("user_id = ?" , session[:user_id])  
	          unless  @equips.blank?
	            redirect_to dashboard_equipos_path, notice: 'El equipo fue borrado exitosamente'
	          else
	            redirect_to dashboard_index_path, notice: 'El equipo fue borrado exitosamente' 
	          end
	        }
	        format.json { head :no_content }
	      end
	    end
	end

	def grid
	    
	    simple = false
	    unless params[:categoria].blank?
	      aux = params[:categoria]
	      simple = true
	    else      
	      aux = params[:category]
	      simple = false
	    end

	    unless params[:subcategory].blank?
	      aux_sub = params[:subcategory]
	      simple_sub = true
	    else      
	      aux_sub = params[:subcategory]
	      simple_sub = false
	    end  
	    
	    @categoria = Category.find_by('categories.title' => aux)
	    @subcategoria = Subcategory.find_by('subcategories.title' => aux_sub)
	    

	    
	    add_breadcrumb @categoria.slug.to_s, Filtro_path('categoria' => @categoria.title,  'tipo' => 1)

	    unless @subcategoria.nil?
	      add_breadcrumb @subcategoria.title.to_s, Filtro_path('categoria' => @categoria.title,'subcategory' => @subcategoria.title ,'tipo' => 1)
	    end
	    tipo = params[:tipo]    
	    cat = Category.find_by('categories.title' => aux)    
	    
	    if simple
	      if simple_sub
	        @equipments = Equipment.where('category_id = ?', cat.id).where('subcategory_id = ?', @subcategoria.id).where_activo.order(sort_column + ' ' + sort_direction)
	      else
	        @equipments = Equipment.where('category_id = ?', cat.id).where_activo.order(sort_column + ' ' + sort_direction)
	      end  
	    else
	      
	      @equipments = Equipment.query(params[:equipment]).where('category_id = ?', cat.id).where_activo.order(sort_column + ' ' + sort_direction)
	      #@equipments = Equipment.query(params[:equipment]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
	    end
    end

    def industry
	    simple = false
	    unless params[:industria].blank?
	      aux = params[:industria]
	      simple = true
	    else      
	      redirect_to root_path,  notice: 'algo salio mal' 
	    end
	    unless params[:equipment].blank?
	      simple = false
	    else      
	      simple = true
	    end
	    
	    @industria = Industry.find_by('industries.title' => aux)

	    if @industria.nil?
	      redirect_to root_path,  notice: 'algo salio mal'
	    end  

	    add_breadcrumb @industria.title.to_s, Filtro_path('industria' => @industria.title,  'tipo' => 1)
	    
	    tipo = params[:tipo]    
	       
	    @aux = IndEquipment.select("equipment_id").where("industry_id = ? ", @industria.id)

	    array = Array.new
	    @aux.each do |a| 
	      array.push(a.equipment_id)
	    end  



	    if simple
	        @equipments = Equipment.where(:id => array).where_activo.order(sort_column + ' ' + sort_direction)
	        puts "#########################################es simple ######################################################"
	        puts @equipments.inspect
	        puts "#########################################################################################################"
	    else  
	      @equipments = Equipment.query(params[:equipment]).where(:id => array).where_activo.order(sort_column + ' ' + sort_direction)
	      puts "#########################################no es simple ######################################################"
	      #@equipments = Equipment.query(params[:equipment]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
	    end
	    
	end

	def preview
	    @equipment = Equipment.friendly.find(params[:id])
	    if @equipment.image_id
	      @image = Image.find(@equipment.image_id)
	    else
	      @image = Image.find_by(image_url: '/data/dummy.png')  
	    end  
	    @gallery = Gallery.where('equipment_id' => @equipment.id)
	    @user = User.find(@equipment.user_id)
	    @currency = Currency.find(@equipment.currency_id)
	    @pack = Package.find(@equipment.package_id)
    end  

  def search
    @equipments = Equipment.search(params[:search]).where_activowhere_renta
  end  

  # GET upgrade
  def master_console
    @equipment = Equipment.friendly.find(params[:equip])
  end
  # Post Upgrade
  def master_console_exe
    @equipment = Equipment.friendly.find(params[:equip])
    respond_to do |format|
      if @equipment.update("priority" => params[:priority], "rank" => params[:rank] )
        format.html { redirect_to dashboard_equipos_path , notice: 'las prioridades para el equipo ' + @equipment.name + ' se han cambiado con exito ' }
        format.json { render :show, status: :ok, location: @equipment }
      else
        format.html { render :edit }
        format.json { render json: @equipment.errors, status: :unprocessable_entity }
      end
    end
  end  

  def contact
    if params[:equipment]
      @equipment = Equipment.friendly.find(params[:equipment]) 
      @user = User.find(@equipment.user_id)
      add_breadcrumb @equipment.name.to_s, equipment_path(@equipment)
    else
      redirect_to root_path
    end
  end

  def sender
    buyer_m = params[:email]
    buyer_n = params[:name]
    buyer_ms = params[:message]
    buyer_p = params[:phone]
    equipment = Equipment.friendly.find(params[:equipment])
    @user = User.find(equipment.user_id)
    seller = @user
    Mailer.equipment_contact(buyer_m,buyer_n,buyer_ms,buyer_p,seller,equipment).deliver
    redirect_to equipment_path(equipment)
  end

  def users_view
    user = params[:user_id]
    @users = User.find(user)
    @equips = Equipment.where('user_id = ?', user).where_renta
  end

  def ver_payment
    #recibe la respuesta de paypal
  end  

  def equip_new
    cpanel = ControlPanel.find_by(:system => "EYM")
    cont = cpanel.newadv
    @equipments = Equipment.where_activo.order("created_at desc").limit(cont)
  end 

  def add_favorito 
    equip = params[:equip]
    @equipment = Equipment.find(equip)
    aux = Favorite.where('user_id = ? and equipment_id = ?' ,session[:user_id],  equip)
    unless equip.nil?
      if aux.nil?
        @favorite = Favorite.new('user_id' => session[:user_id], 'equipment_id' => equip)
       
        respond_to do |format|
          if  @favorite.save
            format.html { redirect_to @equipment, notice: 'se a agregado a favoritos' }
            format.json { render :show, status: :created, location: @equipment }
          else
            format.html { redirect_to @equipment }
            format.json { render json: @favorite.errors, status: :unprocessable_entity }
          end
        end
      else
        redirect_to root_path
      end  
    else
      redirect_to root_path
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_equipment
      @equipment = Equipment.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def equipment_params
      params.require(:equipment).permit(:name, :year, :color, :brand_id, :package_id, :description, :publication_type, :precio, :modelo, :currency_id , :country_id, :state_id, :ciudad, :category_id, :etiquetas, :user_id, :subcategory_id)
    end

    def manejador
      #logger.error "hubo un problema xxyy"
      #redirect_to "/equipment/reporter_grid"
      render action: 'grid'
      @equipment = Equipment.all.where_renta
    #  puts "entre al manejador"
    end

    def propiedad(user_id)
      if user_id == session[:user_id]
        aprovado = true
      else
        aprovado = false
      end  
      return aprovado
    end  

    def sort_column
      params[:sort] || "name"
    end

    def sort_direction
        params[:direction] || "asc"
    end
end

