#!/bin/env ruby
# encoding: utf-8
class WelcomeController < ApplicationController
  skip_before_action :authorize
  def index
    @zone1_a = frontpage(1)
    @zone2_a = frontpage(2)
    @zone3_a = frontpage(3)

    @zone1 = lista_ordenada( @zone1_a)
    @zone2 = lista_ordenada( @zone2_a)
    @zone3 = lista_ordenada( @zone3_a)

    @equipment_slider = principal_slider(8)

  end

  def new
  end

  def create
  	user = User.find_by(username: params[:username])
  	if user and user.authenticate(params[:password])
  		session[:user_id] = user.id
  		session[:uname] = user.name + " " + user.lastname
  		session[:rol_id] = user.rol_id
      #puts "dentro del if"
      #puts "hola" + user.name + " " + user.lastname

      #variables de rol
      rol =Rol.find_by(id: user.rol_id)
      session[:mod0] =rol.admin
      session[:mod1] =rol.module_1
      session[:mod2] =rol.module_2
      session[:mod3] =rol.module_3
      session[:mod4] =rol.module_4
      session[:mod5] =rol.module_5
      #termina variables de rol

      unless session[:lasurl].nil? || session[:lasurl].empty?
  		  redirect_to session[:lasurl]
      else 
        redirect_to root_url
      end

  	else
  		redirect_to root_url, alert: "Invalid user/password combination"
  	end
  end

  def destroy
  	session[:user_id] = nil
  	redirect_to login_url, notice: "Logged out"
  end


  def nosotros
  end

  def especiales
  end

  def marcas
  end

  def contactanos
    @contact = Contact.new
  end    

  private
      def frontpage(pack)
        @equip = Equipment.where('package_id = ?',pack).where_activo.s_charge(pack).order('rank ASC, priority ASC').limit(20)
        return @equip
      end
      def principal_slider(n)
          @equip = Equipment.where_activo.s_principal_charge.order('rank ASC, priority ASC').limit(n)
          return @equip     
      end

      def lista_ordenada(e_obj)
        aux_array_e = Array.new()
        
        e_obj.each do |e|
          aux_array_e << e
        end
       
        final_array = Array.new
        cont = 0
          while !aux_array_e.empty? && cont < 20
            aux_e = aux_array_e.sample
            final_array << aux_e
            aux_array_e.delete(aux_e)
            cont += 1
          end 
        return final_array

      end    
end
