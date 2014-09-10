
#!/bin/env ruby
# encoding: utf-8
class VideosController < ApplicationController
  before_action :set_video, only: [:show, :edit, :update, :destroy]

  # GET /videos
  # GET /videos.json
  def index
        add_breadcrumb I18n.t("breadcrumbs.equipment"), dashboard_equipos_path()
    add_breadcrumb I18n.t("breadcrumbs.gallery"), dashboard_gallerias_path(params[:equip])
    @equip = Equipment.friendly.find(params[:equip])
    @gallery = Gallery.friendly.find(params[:gal])
    @videos = Video.where("gallery_id = ?", @gallery.id)
  end

  # GET /videos/1
  # GET /videos/1.json
  def show
    add_breadcrumb I18n.t("breadcrumbs.equipment"), dashboard_equipos_path()
    add_breadcrumb I18n.t("breadcrumbs.gallery"), dashboard_gallerias_path(params[:equip])
  end

  # GET /videos/new
  def new
    @gallery =Gallery.friendly.find(params[:gal])
    @equipment = Equipment.find(@gallery.equipment_id)
    add_breadcrumb I18n.t("breadcrumbs.equipment"), dashboard_equipos_path()
    add_breadcrumb I18n.t("breadcrumbs.gallery"), dashboard_gallerias_path(params[:equip])   
    #add_breadcrumb I18n.t("breadcrumbs.gallery"), galeria_index_path(@equipment)   
    add_breadcrumb I18n.t("breadcrumbs.newvideo"), video_nuevo_path(@equipment.name, @gallery.title)
    @video = Video.new("gallery_id" => @gallery.id)
  end

  # GET /videos/1/edit
  def edit
  end

  # POST /videos
  # POST /videos.json
  def create
    @a_video = params[:video][:video_url].split(/\.?\s+/)
    @url_suprema =""

    @a_video.each do |vid|
      if not vid.match("width=") || vid.match("height=")
        @url_suprema += " " + vid
      #elsif vid.match("width=")
      #  @url_suprema += " width=\"125\""
      #elsif vid.match("height=")    
      #  @url_suprema += " height=\"70\""
      end 
    end 


    gallery = Gallery.find(params[:video][:gallery_id])
    @video = Video.new("video_url"=> @url_suprema.to_s, "gallery_id"=> gallery.id.to_i, "title"=>params[:video][:title].to_s)
    @equip = Equipment.find(gallery.equipment_id)

    respond_to do |format|
      if @video.save
        format.html { redirect_to dashboard_gallerias_path(@equip.slug), notice: 'Video was successfully created.' }
        format.json { render :show, status: :created, location: @video }
      else
        format.html { render :new }
        format.json { render json: @video.errors, status: :unprocessable_entity }
      end
    end
   
  end

  # PATCH/PUT /videos/1
  # PATCH/PUT /videos/1.json
  def update
    @a_video = params[:video][:video_url].split(/\.?\s+/)
    @url_suprema =""
    @a_video.each do |vid|
      unless vid.match("width=") || vid.match("height=")
        @url_suprema = @url_suprema +" " + vid  
      end
      
    end
    #puts @url_suprema
    params[:video][:video_url] = @url_suprema
    respond_to do |format|
      if @video.update(video_params)
        format.html { redirect_to @video, notice: 'Video was successfully updated.' }
        format.json { render :show, status: :ok, location: @video }
      else
        format.html { render :edit }
        format.json { render json: @video.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /videos/1
  # DELETE /videos/1.json
  def destroy
    gallery = Gallery.find(@video.gallery_id)
    @equip = Equipment.find(gallery.equipment_id)

    @video.destroy
    respond_to do |format|
      format.html { redirect_to galeria_show_path(@equip.slug,gallery.slug), notice: 'Video was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_video
      @video = Video.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def video_params
      params.require(:video).permit(:gallery_id, :video_url, :title)
    end
end
