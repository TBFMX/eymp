#!/bin/env ruby
# encoding: utf-8
class PasswordResetsController < ApplicationController
	skip_before_action :authorize

	def new
	end


	def create
		user = User.find_by_email(params[:email])
		if user.nil?
			redirect_to root_path, :notice => "No encontramos ningun usuario asociado a ese email"
	    else
	    	if user.provider.nil?
	   			user.send_password_reset if user
	   			redirect_to root_url, :notice => "Un email con sus datos de recuperacion a sido enviado a su buzon"
	   		else
	   			if user.provider == "facebook"
	   				redirect_to "https://www.facebook.com/settings?tab=account&section=password&view"
	   			elsif user.provider == "google_oauth2"
	   				redirect_to "https://www.google.com/settings/security?ref=srch"
	   			end	
	   		end
	    end	
	end



	def edit
	  @user = User.find_by_password_reset_token!(params[:id])

	end



	def update
	  @user = User.find_by_password_reset_token!(params[:id])
	  puts "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
	  puts params
	  puts ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
	  puts "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
	  puts @user.inspect
	  puts ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
	  if @user.password_reset_sent_at < 2.hours.ago
	    redirect_to new_password_reset_path, :alert => "Password &crarr; 
	      reset has expired."
	  elsif @user.update_attributes(params.require(:user).permit(:password, :password_confirmation))
	    redirect_to root_url, :notice => "Password has been reset."
	  else
	    render :edit
	  end
	end



end
