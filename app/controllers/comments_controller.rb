#!/bin/env ruby
# encoding: utf-8
class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :edit, :update, :destroy]
=begin
  get 'equipment/comments/:id' => :index    
  get 'comments/new/:id' => :new
  post 'comments/new/:id' => :new
  get 'comments/:id/edit/:equip' => :edit
  post 'comments/:id/edit/:equip' => :edit
=end

  # GET /comments
  # GET /comments.json
  #equipment/comments/:id
  def index
    @equipment = Equipment.friendly.find(params[:id])
    @comments = Comment.where('equipment_id' => @equipment.id)
    add_breadcrumb @equipment.name.to_s, equipment_path(@equipment)
    add_breadcrumb 'comment',comentarios_index_path(@equipment.name)
    
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
    add_breadcrumb @equipment.name.to_s, '/equipment/' + @equipment.id.to_s
    add_breadcrumb 'comment', '/comments/' + @comment.id.to_s

  end

  # GET /comments/new
  #comments/new/:id
  def new
    @comment = Comment.new
   #     add_breadcrumb @equipment.name.to_s, '/equipment/' + @equipment.id.to_s
    #add_breadcrumb 'newcomment', '/comments/' + @comment.id.to_s
  end

  # GET /comments/1/edit
  #comments/:id/edit/:equip
  def edit
    add_breadcrumb @equipment.name.to_s, '/equipment/' + @equipment.id.to_s
    add_breadcrumb 'newcomment', '/comments/' + @comment.id.to_s
  end

  # POST /comments
  # POST /comments.json
  def create
    @comment = Comment.new(comment_params)

    respond_to do |format|
      if @comment.save
        format.html { redirect_to equipment_path(@comment.equipment.id), notice: 'Comment was successfully created.' }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { redirect_to equipment_path(@comment.equipment.id), notice: 'El comentario no puede estar en blanco.' }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @comment, notice: 'Comment was successfully updated.' }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @equipment = Equipment.find(@comment.equipment_id)
    if session[:user_id] === @comment.user_id
      @comment.destroy
      respond_to do |format|
        format.html { redirect_to equipment_path(@equipment), notice: 'Comment was successfully destroyed.' }
        format.json { head :no_content }
      end
    else
      redirect_to equipment_path(@equipment), notice: 'No tienes privilegios para borrar este comentario'
    end   
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:user_id, :equipment_id, :comment)
    end
end
