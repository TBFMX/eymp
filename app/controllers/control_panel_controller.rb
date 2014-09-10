#!/bin/env ruby
# encoding: utf-8
class ControlPanelController < ApplicationController
before_action :acceso_admin

  def index
  end

  def edit
  	@cpanel = ControlPanel.all.limit(1)
  end

  def update
  	@panel
    respond_to do |format|
      if @cpanel.update(cpanel_params)
        format.html { redirect_to dashboard_path, notice: 'La configuracion a sido actualizada exitosamente' }
        format.json { render :show, status: :ok, location: @module1 }
      else
        format.html { render :edit }
        format.json { render json: @module1.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  	def cpanel_params
      params.require(:cpanel).permit(:newadv)
    end

    def acceso_admin
    	if session[:uname] == "admin@admin.com" and session[:rol_id] == 1
    		@aprovado = true
    	else
    		redirect_to root_path, notice: 'Usted no tiene privilegios para hacer moviemientos de este tipo' 	
    	end	
    end	

end
