#!/bin/env ruby
# encoding: utf-8
class ImagesController < ApplicationController
  before_action :set_image, only: [:show, :edit, :update, :destroy]
  include Porta

  # GET galleries/images/:id
  def index
    add_breadcrumb I18n.t("breadcrumbs.equipment"), dashboard_equipos_path()
    if params[:gal].nil?
      redirect_to root_path
    end
    @gallery = Gallery.friendly.find(params[:gal])
    add_breadcrumb I18n.t("breadcrumbs.gallery"), dashboard_gallerias_path(params[:equip])
    @images = Image.where("gallery_id = ?", @gallery.id)
    @equip = Equipment.friendly.find(params[:equip])
  end

  # GET /images/1
  # GET /images/1.json
  def show
    add_breadcrumb I18n.t("breadcrumbs.equipment"), dashboard_equipos_path()
    add_breadcrumb I18n.t("breadcrumbs.gallery"), dashboard_gallerias_path(params[:equip])
  end

  #GET images/new/:id 
  #POST images/new/:id
  def new
    @gallery =Gallery.friendly.find(params[:gal])
    @equipment = Equipment.find(@gallery.equipment_id)
    add_breadcrumb I18n.t("breadcrumbs.equipment"), dashboard_equipos_path()   
    add_breadcrumb I18n.t("breadcrumbs.gallery"), dashboard_gallerias_path(params[:equip])   
    add_breadcrumb I18n.t("breadcrumbs.newimage"), imagen_nueva_path(@equipment.name, @gallery.slug) 
    @image = Image.new("gallery_id" => @gallery.id)
    #@permiso = check_propiety(@equipment)
    #unless @permiso 
    #  redirect_to root_path
    #end
    #@image = Image.new
  end

  #get images/:id/edit/:equip
  #post images/:id/edit/:equip
  def edit
  end
  def select_image
    image_p = params[:image] #id de la imagen
    equip = params[:equipment]
    @equipment = Equipment.friendly.find(equip)
    gallery = params[:gallery]
    respond_to do |format|
      if @equipment.update(:image_id => image_p)
      #  puts "asigno"
        format.html { redirect_to galeria_show_path(@equipment,gallery), notice: 'La imagen principal a sido cambiada.'} 
        format.json {}  
      else
      #  puts "no asigno"
        format.html { redirect_to galeria_show_path(equipment,gallery), notice: 'La imagen principal no pudo ser cambiada, intente mas tarde.' }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end  
  end

  # POST /images
  # POST /images.json
  def create
    @gallery = Gallery.find(params[:image][:gallery_id])
    @equipment= Equipment.find(@gallery.equipment_id)
    @gallery2 = Gallery.find(@gallery)
    #@image = Image.new(image_params)
    @pic = params[:image][:image_url]
    
    unless @pic.blank?
      @pics = DataFile.save(@pic,@equipment.id.to_s, @equipment.name.to_s)
        @image = Image.new("image_url" => @pics, "gallery_id" => params[:image][:gallery_id], "title" => params[:image][:title])
        respond_to do |format|
          if @image.save
            format.html { redirect_to dashboard_imagenes_path(@equipment, @gallery), notice: 'Image was successfully created.' }
            format.json { render :show, status: :created, location: @image }
          else
            format.html { render :new }
            format.json { render json: @image.errors, status: :unprocessable_entity }
          end
        end
    else
      redirect_to imagen_nueva_path(@equipment,@gallery.slug), notice: 'Porfavor cargue una imagen'
      #@pics = "/data/dummy.png"  
    end
  end

  # PATCH/PUT /images/1
  # PATCH/PUT /images/1.json
  def update
    respond_to do |format|
      if @image.update(image_params)
        format.html { redirect_to  '/galleries/' + params[:gallery_id].to_s, notice: 'Image was successfully updated.' }
        format.json { render :show, status: :ok, location: @image }
      else
        format.html { render :edit }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /images/1
  # DELETE /images/1.json
  def destroy
    #me preparo para borrar la imagen  
    @equip = Equipment.find_by('image_id' => @image.id)
    @gal = Gallery.find(@image.gallery_id)
    @count = Image.where('gallery_id = ?', @gal.id).count
    if @count > 1
    @image.destroy
      respond_to do |format|
        format.html { 
          unless @equip.nil?
            n_image = Image.find_by('gallery_id' => @gal.id)
            # puts "-----------------------------------------------------------------------------------------"
            # puts "entro id: " + n_image.id.to_s
            # puts "-----------------------------------------------------------------------------------------"
            respond_to do |format|
              if @equip.update(:image_id => n_image.id)
                #puts "asigno"
                format.html {  redirect_to dashboard_equipos_url, notice: 'Image was successfully destroyed.'} 
                format.json {}  
              else
                #puts "no asigno"
                format.html { redirect_to dashboard_equipos_url, notice: 'Image wasnt successfully destroyed.' }
                format.json { render json: @image.errors, status: :unprocessable_entity }
              end
            end 
          else
            redirect_to dashboard_equipos_url, notice: 'Image was successfully destroyed.'  
          end
        }
        format.json { head :no_content }
      end
    else
      redirect_to dashboard_equipos_url, notice: 'La imagen no puede ser destruida'  
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_image
      @image = Image.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def image_params
      params.require(:image).permit(:gallery_id, :image_url, :title)
    end
end
