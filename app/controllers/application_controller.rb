#!/bin/env ruby
# encoding: utf-8
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authorize
  before_action :menu_categorias
  before_action :menu_industrias

#aplico las traducciones
 before_action :set_locale
#aplico el handler
  protect_from_forgery with: :exception
#aplico las restricciones
  before_action :authorize

#genera el breadcrumb con sus traducciones y agrega el elemento home.
 add_breadcrumb I18n.t("breadcrumbs.homepage"), :root_path
 
  unless Rails.application.config.consider_all_requests_local
    rescue_from Exception, :with => :render_error
    rescue_from ActiveRecord::RecordNotFound, :with => :render_not_found   
    rescue_from ActionController::RoutingError, :with => :render_not_found
  end
 
  #called by last route matching unmatched routes.  Raises RoutingError which will be rescued from in the same way as other exceptions.
  def raise_not_found2
    #raise ActionController::RoutingError.new("No route matches #{params[:unmatched_route]}")
    redirect_to root_url
    #redirect_to root_url
  end
 
  #render 500 error
  def render_error(e)
    respond_to do |f|
      f.html{ render :template => "errors/500", :status => 500 }
      f.js{ render :partial => "errors/ajax_500", :status => 500 }
    end
  end
 
  #render 404 error
  def render_not_found(e)
    respond_to do |f|
      f.html{ render :template => "errors/404", :status => 404 }
      f.js{ render :partial => "errors/ajax_404", :status => 404 }
    end
  end
#verica que el objeto de guarde en la base de datos correctamente (se usa a mano en casos de objetos que se generan automaticamente sin intervencion del usuario)
  def secure_save(variable)
      begin
        if variable.save
          return true
        end
    rescue ActiveRecord::RecordNotFound    
      # handle not found error
      logger.error "no se encontro el registro que se solicito"
      return false
    rescue ActiveRecord::ActiveRecordError
      # handle other ActiveRecord errors
      logger.error ("hubo un error en el ActiveRecord" + logger.debug)
          rescue # StandardError
      # handle most other errors
    rescue Exception
      # handle everything else
    end
  end
#metodo que verifica la existencia de la variable (se usa a mano en donde se ocupe)
  def var_verify(variable)
    begin
      if variable
          return true
      end
    rescue ActiveRecord::RecordNotFound    
      # handle not found error
      logger.error "no se encontro el registro que se solicito"
      # puts "-------------------------------------------------------------"
      # puts "no se encontro el Record"
      # puts variable.inspect
      # puts "-------------------------------------------------------------"
      return false
    rescue ActiveRecord::ActiveRecordError
      # handle other ActiveRecord errors
      logger.error ("hubo un error en el ActiveRecord" + logger.debug)
          rescue # StandardError
      # handle most other errors
    rescue Exception
      # handle everything else
      # puts "-------------------------------------------------------------".
      # puts "ocurrio una excepcion"
      # puts variable.inspect
      # puts "-------------------------------------------------------------"

    end
  end

#funcion que administra los errores de servidor
  def server_error(exception)
  # Whatever code that handles the exception

      ExceptionNotifier.notify_exception(exception,
    :env => request.env, :data => {:message => "was doing something wrong"})
  end

#funcion que activa las traducciones
  def set_locale
    I18n.locale = :es || I18n.default_locale
  end

  def var_get_verify(array, parametros)
    array.each do |a|
      if parametros[a].blank?
        return false
      end  
    end 
    return true 
  end
 
  def record_exist(obj)
    if obj.blank?
      redirect_to root_url
    end  
  end

 
#funcion de control de acceso
  protected
      def authorize
          unless User.find_by(id: session[:user_id])
              #session[:lasurl]= request.original_url
              redirect_to login_url , notice: "Please log in"
          end        
      end

      def menu_categorias
        @category_m = Category.all
        @subcategory_m = Subcategory.all
      end
      def menu_industrias
        @industry_m = Industry.all
      end      
      def current_user
        @current_user ||= User.find(session[:user_id]) if session[:user_id]
      end
        helper_method :current_user


end
