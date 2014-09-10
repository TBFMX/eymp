#!/bin/env ruby
# encoding: utf-8
class AdminController < ApplicationController
  def index
  	@total_users = User.count
  end
end
