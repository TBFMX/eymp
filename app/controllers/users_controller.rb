#!/bin/env ruby
# encoding: utf-8
class UsersController < ApplicationController
  before_action :autorizar
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  skip_before_action :authorize, only: [:recover_password, :new_recover_password]
  skip_before_action :autorizar, only: [:cambiar_password, :new_cambiar_password]
  skip_before_action :autorizar, only: [:new,:create, :update]
  skip_before_action :authorize, only: [:new,:create]
  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new('rol_id' => 2)
  end

  # GET /users/1/edit
  def edit
  end

  def new_recover_password
  end

  def new_cambiar_password
    @user = User.find_by(id: session[:user_id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        Mailer.create_user(@user).deliver
        format.html { login2(@user.email,@user.password)
         #redirect_to @user, notice: "El usuario #{@user.username} fue creado exitosamente." 
       }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    if session[:user_id] == @user.id or session[:uname] == "admin@admin.com"
      
      respond_to do |format|
        if @user.update(user_params)
        
          format.html { redirect_to dashboard_login_path, notice: "El usuario #{@user.username} fue actualizado exitosamente." }
          format.json { render :show, status: :ok, location: @user }
        else
         
          format.html { redirect_to dashboard_login_path, notice: "El usuario #{@user.username} no pudo ser actualizado." }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to root_path , notice: " no esta autorizado para hacer esa accion"
    end  
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    begin
      @user.destroy
      Mailer.destroy_user(@user).deliver
      flash[:notice] = "User #{@user.username} deleted"
    rescue StandardError => e
      flash[:notice] = e.message
    end
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end


  def reset_password
    @user = User.where(["username= ? and email= ?",params[:username],params[:email]])
    if @user.empty?
      redirect_to root_path
    else
    puts params  
    @user.update(user_params) 
    Mailer.reset_password(@user,params[:email]).deliver 
    end 
  end
  
  def cambiar_password
    @user = User.find(params[:id]) 
    Mailer.cambiar_password(@user).deliver  

  end 

  def recover_password
    @user = User.where(["username= ? and email= ?",params[:username],params[:email]])
    if @user.empty?
      redirect_to root_path
    else
      #puts @user.inspect
      Mailer.recover_password(@user,params[:email]).deliver 
      redirect_to users_url
    end   
  end
   

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    def autorizar
        unless session[:mod0] == true
          redirect_to root_path , notice: " no esta autorizado para hacer esa accion"
        end
    end

    def login2(email, password) 
      user = User.find_by(username: email)
      if user and user.authenticate(password)
        session[:user_id] = user.id
        session[:uname] = user.username
        session[:rol_id] = user.rol_id
      #   puts "---------------------holaaaaaaaaaaa222222222222-------------------"
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
        redirect_to root_path, alert: "Invalid user/password combination"
      end
    end
    

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      unless params[:user][:email].blank?
        if params[:user][:username].blank?
          params[:user][:username] = params[:user][:email]  
        end
      end  


      
      params[:user][:rol_id] = 2
      params.require(:user).permit(:username, :password, :password_confirmation, :name, :lastname, :email, :login_date, :password_date, :rol_id)
    end
end
