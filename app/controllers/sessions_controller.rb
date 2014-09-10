#!/bin/env ruby
# encoding: utf-8
class SessionsController < ApplicationController

  skip_before_action :authorize

  def new
  end

  def new_en
  end

  def createfb
  

    if params[:error] == "access_denied"
      redirect_to root_url  
    end  

    user = User.from_omniauth(env["omniauth.auth"])
    unless user.blank?
      session[:user_id] = user.id
      session[:uname] = user.username
      session[:rol_id] = user.rol_id
       
      #variables de rol
      rol =Rol.find_by(id: user.rol_id)
      session[:mod0] =rol.admin
      session[:mod1] =rol.module_1
      session[:mod2] =rol.module_2
      session[:mod3] =rol.module_3
      session[:mod4] =rol.module_4
      session[:mod5] =rol.module_5
      redirect_to root_url
    else
      
      redirect_to root_url ,notice: 'ya existe una cuenta con ese email asignado'  
    end
  end  

  def create
  	user = User.find_by(username: params[:username])
  	if user and user.authenticate(params[:password])
  		session[:user_id] = user.id
      session[:uname] = params[:username]
  		session[:rol_id] = user.rol_id
       #puts "---------------------holaaaaaaaaaaa222222222222-------------------"
      #variables de rol
      rol =Rol.find_by(id: user.rol_id)
      session[:mod0] =rol.admin
      session[:mod1] =rol.module_1
      session[:mod2] =rol.module_2
      session[:mod3] =rol.module_3
      session[:mod4] =rol.module_4
      session[:mod5] =rol.module_5
      #termina variables de rol
      unless session[:lasurl].blank?
        aux = session[:lasurl]
        session[:lasurl] = ""
  		  redirect_to aux
      else
        redirect_to root_path
      end    
  	else
  		redirect_to login_path, alert: "La combinacion de Usuario y clave es incorrecta"
  	end
  end

  def create_en
    user = User.find_by(username: params[:username])
    if user and user.authenticate(params[:password])
      session[:user_id] = user.id
      session[:uname] = params[:username]
      session[:rol_id] = user.rol_id
      #variables de rol
      rol =Rol.find_by(id: user.rol_id)
      session[:mod0] =rol.admin
      session[:mod1] =rol.module_1
      session[:mod2] =rol.module_2
      session[:mod3] =rol.module_3
      session[:mod4] =rol.module_4
      session[:mod5] =rol.module_5
      #termina variables de rol
      unless session[:lasurl].blank?
        aux = session[:lasurl]
        session[:lasurl] = ""
        redirect_to aux
      else
        redirect_to "/equipment/new"
      end    
    else
      redirect_to root_path, alert: "La combinacion de Usuario y clave es incorrecta"
    end
  end



  def destroy
  	#session[:user_id] = nil
    reset_session
  	redirect_to root_path, notice: "Logged out"
  end
end
