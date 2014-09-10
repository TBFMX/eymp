#!/bin/env ruby
# encoding: utf-8
class DashboardController < ApplicationController
  before_action :charge_all
  skip_before_action :authorize, only: [:login]


  def index
    @user = User.find(session[:user_id])
  end

  def login
    add_breadcrumb "Administrar cuenta"
     @user = User.find(session[:user_id])  
     #puts "---------------------------------"
     #puts @user.inspect
     #puts "---------------------------------"     
  end

  #mis equipos
  
  def equipos
    add_breadcrumb I18n.t("breadcrumbs.equipment"), dashboard_equipos_path()
    @equipment = Equipment.where("user_id = ?" , session[:user_id]).where_activo
    @equipment2 = Equipment.where("user_id = ?" , session[:user_id]).where_inactivo
    @equipment3 = Equipment.where("user_id = ?" , session[:user_id]).where_desactivado
  end

  def gallerias
    add_breadcrumb I18n.t("breadcrumbs.equipment"), dashboard_equipos_path()    
    @equips = Equipment.friendly.find(params[:equip])
    @galleries = Gallery.where("equipment_id = ?", @equips)
    #if params[:gal]
    #  @galleries = Gallery.friendly.find(params[:gal])
    #end  
    #puts "----------Gallery-----------------------"
    #puts @galleries.inspect
    # puts "----------------------------------------"

    # puts "---------------- equipment -----------------"
    # puts @equips.inspect
    # puts "---------------------------------"
      @e_id = @equips.slug
  end

  def imagenes
    @equips = Equipment.friendly.find(params[:equip])
    if params[:gal]
     # puts "----------Gallery-----------------------"
     # puts  params[:gal]
     # puts "----------------------------------------"
      @galleries = Gallery.friendly.find(params[:gal])
      @images = Image.where("gallery_id = ?" , @galleries.id)
    else
      redirect_to root_path  
    end  
  end

  def videos
    @equips = Equipment.friendly.find(params[:equip])
    @galleries = Gallery.friendly.find(params[:gal])
    @videos = Video.where("gallery_id = ?" , @galleries.id)
  end

  def cuenta       
  end 

  def favorites
    @favoritos = Favorite.select("equipment_id").where("user_id = ?" , session[:user_id])
    array = Array.new
    @favoritos.each do |f|
      array.push(f.equipment_id)
    end
    @equipment = Equipment.where(:id => array).where_activo
  end
  ##generadores de pdf
  def contact_rep
    #@contacts = Contact.find_by_sql("select c.* from contactos c, equipment e where e.user_id = ? and e.id == c.equipment_id group by c.equipment_id order by c.name")
    respond_to do |format|
      format.html
      format.pdf do
        render :pdf => "report", :layout => 'pdf.html.erp'
      end
    end
  end 
=begin  
  def operations_rep
    @operations = Product.all
    respond_to do |format|
      format.html
      format.pdf do
        render :pdf => "report", :layout => 'pdf.html.haml'
      end
    end
  end 
=end
  ##generadores de pdf
  def equipments_status_rep
    @equips = Equipment.where('user_id = ?', seesion[:user_id])
    respond_to do |format|
      format.html
      format.pdf do
        render :pdf => "report", :layout => 'pdf.html.erb'
      end
    end
  end

  def equip_history
    @equipment = Equipment.where("user_id = ?", session[:user_id]).order('created_at ASC')
  end  
  
  #def report_status
  #  @equipments = Equipment.search(params[:search]).where_activo
  #end

  def report_status
    #simple = false
    ##aqui van los campos indispensables
    @user_id = session[:user_id]
    ##terminan indispensables
    add_breadcrumb "Reporte de Status", reporte_status_path('tipo' => 1)

    tipo = params[:tipo]    
    @equipments = Equipment.query_rep_stat(params[:equipment]).where('user_id = ?', @user_id).where_activo.order(sort_column + ' ' + sort_direction)
  end


  private
    def charge_all
 
    @equips = Equipment.find_by("user_id = ?" , session[:user_id])
    unless  @equips.blank?
        @equipsWhere = Equipment.where("user_id = ?" , session[:user_id]).where_activo    
    
        #@galleries = Gallery.find_by("equipment_id = ?" , @equips.id)                 
        @galleriesWhere = Gallery.where("equipment_id = ?" , @equips.id)
        unless @galleries.blank?
          @images = Image.where("gallery_id = ?" , @galleries.id)             
          @videos = Video.where("gallery_id = ?" , @galleries.id)    
        end
        @verificado = true
      else
        @verificado = false
      end
      @verificado  
    end  

    

end
