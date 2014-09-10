#!/bin/env ruby
# encoding: utf-8
class EquipmentController < ApplicationController
  before_action :set_equipment, only: [:show, :edit, :update, :destroy]
  before_action :set_new_equipment, only: [:new]
  helper_method :sort_column, :sort_direction
  skip_before_action :authorize, only: [:show,:grid,:search,:industry,:listado]

  # GET /equipment
  # GET /equipment.json
  def index
    @equipment = Equipment.where_activo.where_venta
  end

  # GET /equipment/1
  # GET /equipment/1.json
  def show
    if be_active (@equipment)
      #@photo = @equipment.photo.url
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
    else
      redirect_to root_path
    end   
  end

  # GET /equipment/new
  def new
    add_breadcrumb I18n.t("breadcrumbs.newequipment"), new_equipment_path
    #@equipment = Equipment.new('user_id' => session[:user_id])
    #@package = Package.all
    puts "---------------------------Paquetes---------------------------------"
    puts @package.inspect
    puts "--------------------------------------------------------------------"
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
    puts "-------------------parametros---------------------------"
      puts params.inspect
    puts "----------------------------------------------"
      @pic = params[:equipment][:image_id]
    respond_to do |format|
      if secure_save(@equipment)
        format.html { 
          #saco la id del proyecto
          @equipments = Equipment.find(@equipment)
          # puts "-------------------Equipo-----------------------------"
          # puts @equipments.inspect
          # puts "------------------------------------------------------"
          #creo la galleria
            @gallery=Gallery.new("equipment_id"=>@equipments.id, "title" =>"principal")
            # puts "--------------------Galleria--------------------------"
            # puts @gallery.inspect
            # puts "------------------------------------------------------"
            respond_to do |format|
              if secure_save(@gallery)
                format.html {
                  if params[:equipment][:photo]
                    @galleries = Gallery.find(@gallery)
                      #unless @pic.nil?
                        #puts "pase la validacion de pic"
                        @image = Image.new("gallery_id" => @galleries.id, "photo" => params[:equipment][:photo])
                        #@image = Image.new(params[:equipment][:photo])
                        puts "--------------------Imagen--------------------------"
                        puts "hola "
                        puts @image.inspect
                        puts "----------------------------------------------------"
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
                            } #set_new_equipment
                            format.json { }
                          else
                          #  puts "entre a imagen"
                            format.html { redirect_to root_path, alert: "fallo el salvado de la imagen" }
                            format.json {  }
                          end
                        end
                      #else
                      #  redirect_to @equipment, notice: 'falle'
                      #end
                  else #else de si no hay params
                      Mailer.create_equip(@user,@equipment).deliver
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
        format.html { render :new , alert: "asegurece de llenar los campos obligatorios"  }
        format.json { render json: @equipment.errors, status: :unprocessable_entity }
      end
    end    
  end

  # PATCH/PUT /equipment/1
  # PATCH/PUT /equipment/1.json
  def update
    if propiedad(@equipment.user_id)
      @pic = params[:equipment][:image_id]
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
                @gallery=Gallery.where("equipment_id = ? and title = 'principal' ", @equipment.id ).first
              else
                @gallery=Gallery.new("equipment_id"=>@equipment.id, "title" =>"principal")
              end    
                respond_to do |format|
                  if secure_save(@gallery)
                    format.html {
                      @galleries = Gallery.find(@gallery)
                          @image = Image.new("gallery_id" => @galleries.id, "image_url" => @pics)
                          puts "--------------------Imagen--------------------------"
                          puts @image.inspect
                          puts "----------------------------------------------------"
                          
                          respond_to do |format|
                            if secure_save(@image)
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
    #@equipment.destroy
    respond_to do |format|
      if @equipment.update("status" => 3)
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

  def reactivate
    equip = params[:equipment]
    @equipment = Equipment.friendly.find(equip)
    if propiedad(@equipment.user_id)
      respond_to do |format|
        if @equipment.update(:status => 0)
          format.html { redirect_to dashboard_equipos_path, notice: 'favor de realizar el pago para concluir la re-activación'}
          format.json {}
        else
          format.html { redirect_to dashboard_equipos_path, notice: 'el equipo no pudo ser re-activado por favor intente de nuevo mas tarde'}
          format.json {}
        end
      end    
    else
      redirect_to dashboard_equipos_path, notice: 'no esta autorizado a hacer cambios en ese equipo' 
    end  
  end  

  def grid
    url = request.url
    puts "-----------------------------"
    puts url
    puts "-----------------------------"
    puts "-----------------------------"
    puts params.inspect
    puts params[:array].inspect
    puts "-----------------------------"
    simple = false

    @array = params[:array]

    nombre = params[:nuevo_n]
    valor = params[:nuevo_v]

    unless nombre.blank? and valor.blank?
      @array[nombre] = valor
    end
    unless params[:array].blank?
      unless params[:array][:categoria].blank?
        aux = params[:array][:categoria]
        simple = true
      else
        unless params[:categoria].blank?      
          aux = params[:categoria]
          simple = false     
        else      
          redirect_to root_path
        end  
      end
    else
      unless params[:categoria].blank?      
        aux = params[:categoria]
        simple = false     
      else      
        redirect_to root_path
      end    
    end
    #puts "------------------------------------"
    #puts "auxiliar: " + aux.to_s
    #puts "------------------------------------"



    unless params[:array].blank?
      unless params[:array][:subcategory].blank?
        aux_sub = params[:array][:subcategory]
        simple_sub = true
      else      
        aux_sub = params[:subcategory]
        simple_sub = false
      end
    else      
        aux_sub = params[:subcategory]
        simple_sub = false      
    end

    @categoria = Category.find_by('categories.title' => aux)
    #puts "------------------------------------"
    #puts @categoria.inspect
    #puts "------------------------------------"

    @subcategoria = Subcategory.find_by('subcategories.title' => aux_sub)
    filtros = Hash['categoria' => @categoria.title ,'tipo' => 1]

    add_breadcrumb @categoria.slug.to_s, Filtro_path('array' => filtros)
    @titulo = @categoria.title.to_s

    unless @subcategoria.nil?
      filtros = Hash['categoria' => @categoria.title ,'subcategory' => @subcategoria.title ,'tipo' => 1]
      add_breadcrumb @subcategoria.title.to_s, Filtro_path('array' => filtros)
       @titulo = @subcategoria.title.to_s
    end

    tipo = params[:tipo]    
    @cat = Category.find_by('categories.title' => aux)    
    
    if simple
      if simple_sub
        @equipments = Equipment.where('category_id = ?', @cat.id).where('subcategory_id = ?', @subcategoria.id).query(@array).where_activo.where_venta.order(sort_column + ' ' + sort_direction)
      else
        @equipments = Equipment.where('category_id = ?', @cat.id).query(@array).where_activo.where_venta.order(sort_column + ' ' + sort_direction)
      end  
    else
      @equipments = Equipment.query(@array).where('category_id = ?', @cat.id).where_activo.where_venta.order(sort_column + ' ' + sort_direction)
      #@equipments = Equipment.query(params[:equipment]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
    end

    ##########varibles de contenido###############
    @marcas_a = Array.new
    @equipos_a = Array.new
    @monedas_a = Array.new 
    @paises_a = Array.new
    @estados_a = Array.new
    ############################################be_active (equip)##


    @equipments.each do |o|
      @marcas_a.push(o.brand_id)
    end

    @equipments.each do |o|
        @equipos_a.push(o.id)
    end

    @equipments.each do |o|
        @monedas_a.push(o.currency_id)
    end

    @equipments.each do |o|
        @paises_a.push(o.country_id)
    end

    @equipments.each do |o|
        @estados_a.push(o.state_id)
    end
  end

  def industry
    #######################################
    url = request.url
    puts "-----------------------------"
    puts url
    puts "-----------------------------"
    puts "-----------------------------"
    puts params.inspect
    puts params[:array].inspect
    puts "-----------------------------"
    simple = false

    @array = params[:array]

    nombre = params[:nuevo_n]
    valor = params[:nuevo_v]

    unless nombre.blank? and valor.blank?
      @array[nombre] = valor
    end
    unless params[:array].blank?
      unless params[:array][:industria].blank?
        aux = params[:array][:industria]
        simple = true
      else
        unless params[:industria].blank?      
          aux = params[:industria]
          simple = false     
        else      
          redirect_to root_path
        end  
      end
    else
      unless params[:industria].blank?      
        aux = params[:industria]
        simple = false     
      else      
        redirect_to root_path
      end    
    end
    #######################################

    
    
    @industria = Industry.find_by('industries.title' => aux)

    if @industria.nil?
      redirect_to root_path,  notice: 'algo salio mal'
    end  

    add_breadcrumb @industria.title.to_s, industry_path('industria' => @industria.title)
    
    tipo = params[:tipo]    
       
    @aux = IndEquipment.select("equipment_id").where("industry_id = ? ", @industria.id)

    array = Array.new
    @aux.each do |a| 
      array.push(a.equipment_id)
    end  
    if simple
        @equipments = Equipment.where(:id => array).where_activo.where_venta.order(sort_column + ' ' + sort_direction)
    else  
      @equipments = Equipment.query(params[:equipment]).where(:id => array).where_activo.where_venta.order(sort_column + ' ' + sort_direction)
      #puts "#########################################no es simple ######################################################"
      #@equipments = Equipment.query(params[:equipment]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 10, :page => params[:page])
    end

    ##########varibles de contenido###############
    @marcas_a = Array.new
    @equipos_a = Array.new
    @monedas_a = Array.new 
    @paises_a = Array.new
    @estados_a = Array.new
    ##############################################
    @equipments.each do |o|
      @marcas_a.push(o.brand_id)
    end

    @equipments.each do |o|
        @equipos_a.push(o.id)
    end

    @equipments.each do |o|
        @monedas_a.push(o.currency_id)
    end
    @equipments.each do |o|
        @paises_a.push(o.country_id)
    end

    @equipments.each do |o|
        @estados_a.push(o.state_id)
    end
    
  end

  def preview
    @equipment = Equipment.friendly.find(params[:id])
    if @equipment.image_id
      @image = Image.find(@equipment.image_id)
    else
      @image = Image.find_by(image_url: '/data/dummy.png')  
    end 
    ################contenido heredable##############
    @gallery = Gallery.where('equipment_id' => @equipment.id)
    @user = User.find(@equipment.user_id)
    @currency = Currency.find(@equipment.currency_id)
    @pack = Package.find(@equipment.package_id)
    #################################################
  end  

  def search
    #if params[:search].blank?
    #  params[:search] = "  "
    #end
    @search = params[:search]
    @equipments = Equipment.search(params[:search]).where_activo.where_venta.order(sort_column + " " + sort_direction)
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


  def temporal

  end  


  def users_view
    array = Array.new
    array.push("user_id")
    if var_get_verify(array, params)
      user = params[:user_id]
      @users = User.find(user)
      record_exist(@users) #valida que el registro no sea blanco o nullo
      @equips = Equipment.where('user_id = ?', user).where_venta.where_activo
      record_exist(@users)
    else
      redirect_to root_path  
    end  
  end

  def ver_payment
    #recibe la respuesta de paypal
  end  

  def equip_new
    cpanel = ControlPanel.find_by(:system => "EYM")
    cont = cpanel.newadv
    @equipments = Equipment.where_activo.where_venta.order("created_at desc").limit(cont)
  end 

  def add_favorito 
    equip = params[:equip]
    @equipment = Equipment.find(equip)
    
    aux = Favorite.where('user_id = ? and equipment_id = ?' ,session[:user_id],  equip)
    
    unless equip.nil?
      #puts ">>>>>>>>>>>>>>>>>>>>>>>>>>equipo no nil"
      if aux.blank?
        @favorite = Favorite.new('user_id' => session[:user_id], 'equipment_id' => equip)
        #puts ">>>>>>>>>>>>>>>>>>>>>>>>>>aux blank"
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
        #puts ">>>>>>>>>>>>>>>>>>>>>>>>>>aux no blank"
        redirect_to root_path
      end  
    else
      redirect_to root_path
    end
  end

  def removed_favoritos
    
    equip = params[:equip]
    favorito = params[:favorito]
    aux = Favorite.find(favorito)
    aux.destroy
    respond_to do |format|
      format.html { redirect_to equipment_path(equip), notice: 'a sido removido de favoritos' }
      format.json { head :no_content }
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_equipment
      @equipment = Equipment.friendly.find(params[:id])
    end
    def set_new_equipment
      @equipment = Equipment.new('user_id' => session[:user_id])
      @package = Package.all
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def equipment_params
      params.require(:equipment).permit(:name, :year, :color, :brand_id, :package_id, :description, :publication_type, :precio, :modelo, :currency_id , :country_id, :state_id, :ciudad, :category_id, :etiquetas, :user_id, :subcategory_id)
    end

    def be_active (equip)
      @aux = Equipment.where(id: equip.id).where_activo
      unless @aux.blank?
        answer = true
      else
        answer = false
      end  
      return answer

    end
    def manejador
      #logger.error "hubo un problema xxyy"
      #redirect_to "/equipment/reporter_grid"
      render action: 'grid'
      @equipment = Equipment.all
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

    def fill_array(equipo,campo)
      aux = Array.new

      objeto.each do |o|
        aux.push(o.campo)
      end 
      return aux
    end  
end
